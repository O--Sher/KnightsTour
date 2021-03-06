//
//  KTWarnsdorffsAlgorithm.swift
//  KnightsTour
//
//  Created by Oleg Sher on 26.06.17.
//  Copyright © 2017 OSher. All rights reserved.
//

import Foundation

class KTWarnsdorffsAlgorithm: KTKnightTourAlgorithm {
    
    // MARK: Vars
    
    var isRepeatCellEnabled: Bool = false
    var presenterView: KTKnightTourPresenterView?
    var delegate: KTKnightTourAlgorithmDelegate?
    
    private var tour: TourComputation?
    
    fileprivate var timer: Timer?
    fileprivate var operations: [()->Void] = []
    
    // MARK: Actions
    
    func runSearch() {
        guard let boardSize = presenterView?.boardSize else {
            fatalError("Failed to retrieve board size")
        }
        guard let startCell = presenterView?.startCell,
            startCell.isEmpty == false,
            let startPosition = Position(cellName: startCell) else {
            fatalError("Failed to retrieve start position")
        }
        
        presenterView?.clearProgress()
        sceduleTimer()
        
        tour = TourComputation(boardSize: boardSize, start: startPosition)
        tour?.delegate = self
        tour?.isRunning = true
        tour?.isRepeatCellEnabled = isRepeatCellEnabled
        
        DispatchQueue.global().async {
            if let path = self.tour?.compute() {
                print("\(path)")
            }
        }
    }
    
    func stopSearch() {
        tour?.isRunning = false
        timer?.invalidate()
        timer = nil
        operations.removeAll()
    }
    
    // MARK: Private
    
    private func sceduleTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(runOperation), userInfo: nil, repeats: true)
    }
    
    @objc private func runOperation() {
        if let operation = operations.popLast() {
            DispatchQueue.main.async {
                operation()
            }
        }
        if operations.count == 0 {
            self.stopSearch()
            DispatchQueue.main.async {
                self.delegate?.searchFinished()
            }
        }
    }
    
    fileprivate func addOperation(_ operation: @escaping ()->Void) {
        operations.insert(operation, at: 0)
    }
}

// MARK: - TourComputationDelegate

extension KTWarnsdorffsAlgorithm: TourComputationDelegate {
    func moveTo(cell: String, count: Int) {
        addOperation {
            self.presenterView?.didMoveToCell(cell, stepCount: count)
        }
    }
    
    func stepBackTo(cell: String) {
        addOperation{
            self.presenterView?.goBackToCell(cell)
        }
    }
    
    func finished() {
        stopSearch()
    }
}

// MARK: - Position -

public struct Position: Hashable, Equatable, CustomStringConvertible {
    var x: Int
    var y: Int
    
    public var hashValue: Int {
        return x * 123 + y
    }
    
    public static func ==(lhs: Position, rhs: Position) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    public var description: String {
        get {
            return "(\(x),\(y))"
        }
    }
}

extension Position {
    static var alphas: String {
        return "abcdefghijklmnop"
    }
    
    init?(cellName: String) {
        guard let letter = cellName.characters.first,
           let letterIndex = Position.alphas.characters.index(of: letter)
            else { fatalError("Failed to retrieve letter") }

        let number = cellName.substring(from: cellName.index(cellName.startIndex, offsetBy: 1))
        guard let y = Int(number) else { fatalError("Failed to retrieve number") }
        
        let x: Int = Position.alphas.distance(from: Position.alphas.startIndex, to: letterIndex)
        self.init(x: x, y: y - 1)
    }
    
    var stringFormat: String {
        let letter = Position.alphas.characters.map{ String($0) }[x]
        let number = String(y+1)
        return letter + number
    }
}

// MARK: - TourComputation -

fileprivate struct TourComputation {
    private struct Move {
        var position: Position
        var availableNextSteps: [Position]
    }
    
    var delegate: TourComputationDelegate?
    
    var isRunning: Bool = false
    var isRepeatCellEnabled: Bool = false
    
    private var boardSize: Int
    
    private var visited: Set<Position> = []
    private var path: [Move] = []
    
    init(boardSize: Int, start position: Position) {
        self.boardSize = boardSize
        visited.insert(position)
        path.append(Move(position: position, availableNextSteps: nextStepsWithinTheBoard(from: position)))
    }
    
    // MARK: - Logic
    
    mutating func compute() -> [Position] {
        var failsCount: Int = 0
        
        while visited.count != boardSize*boardSize && !path.isEmpty && isRunning {
            let currentMove = path.popLast()!
            let currentPosition = currentMove.position
            let nextSteps = currentMove.availableNextSteps
            
            func moveTo(position: Position) {
                remove(nextPosition: position, from: currentMove)
                makeNextMove(to: position)
            }
            
            guard let nextPosition = chooseNextStep(outof: nextSteps) else {
                // no available next steps
                
                failsCount += 1
                if failsCount >= 100 {
                    return path.map { $0.position }
                }
                
                if isRepeatCellEnabled {
                    guard let visitedPosition = path.last else {
                        return path.map { $0.position }
                    }
                    moveTo(position: visitedPosition.position)
                } else {
                    visited.remove(currentPosition)
                    
                    // Displaying step back
                    if let previousStep = path.last?.position {
                        delegate?.stepBackTo(cell: previousStep.stringFormat)
                    }
                }
                
                continue
            }
            
            moveTo(position: nextPosition)
        }
        
        return path.map { $0.position }
    }
    
    // remove chosen from nextSteps
    private mutating func remove(nextPosition: Position, from currentMove:Move) {
        let modifiedNextSteps = currentMove.availableNextSteps.filter { $0 != nextPosition }
        
        // have to modify last move's next moves to not repeat
        let modifiedLastMove = Move(position: currentMove.position, availableNextSteps: modifiedNextSteps)
        path.append(modifiedLastMove)
        
        // Displaying move
        delegate?.moveTo(cell: nextPosition.stringFormat, count: path.count)
    }
    
    // making the next move
    private mutating func makeNextMove(to nextPosition: Position) {
        visited.insert(nextPosition)
        let availableNextSteps = nextStepsWithinTheBoard(from: nextPosition).filter { !visited.contains($0) }
        let nextMove = Move(position: nextPosition, availableNextSteps: availableNextSteps)
        path.append(nextMove)
    }
    
    // MARK: - Search possible steps
    
    // Warnsdorfss rule - choosing step with less possible next steps
    private func chooseNextStep(outof nextSteps: [Position], filter: Bool = true) -> Position? {
        if nextSteps.isEmpty { return nil }
        
        if filter == false {
            let rand = Int(arc4random_uniform(UInt32(nextSteps.count)))
            let result = nextSteps[rand]
            return result
        }
            
        var minCount = 8
        var result = nextSteps.first!
        for position in nextSteps {
            let count = nextStepsWithinTheBoard(from: position).filter {
                !visited.contains($0) }.count
            if count < minCount {
                minCount = count
                result = position
            }
        }
        return result
    }
    
    private func nextStepsWithinTheBoard(from currentPosition: Position) -> [Position] {
        let moves = nextSteps(from: currentPosition).filter { (position) -> Bool in
            // checking if position is on board
            return  position.x >= 0 &&
                position.x < boardSize &&
                position.y >= 0 &&
                position.y < boardSize;
        }
        return moves
    }
    
    private func nextSteps(from c: Position) -> [Position] {
        let jumps = [(-2,-1),(-1,-2),(-2,1),(-1,2),(1,-2),(2,-1),(1,2),(2,1)]
        let moves = jumps.map { (x,y) -> Position in
            Position(x: c.x + x, y: c.y + y)
        }
        return moves
    }
}

// MARK: -

protocol TourComputationDelegate {
    func moveTo(cell: String, count: Int)
    func stepBackTo(cell: String)
    func finished()
}
