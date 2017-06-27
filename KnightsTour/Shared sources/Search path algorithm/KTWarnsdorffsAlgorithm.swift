//
//  KTWarnsdorffsAlgorithm.swift
//  KnightsTour
//
//  Created by Oleg Sher on 26.06.17.
//  Copyright © 2017 OSher. All rights reserved.
//

import Foundation

class KTWarnsdorffsAlgorithm: KTKnightTourAlgorithm {
    var isRepeatCellEnabled: Bool = false
    var presenterView: KTKnightTourPresenterView?
    var delegate: KTKnightTourAlgorithmDelegate?
    
    private var tour: TourComputation?
    
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
        tour = TourComputation(boardSize: boardSize, start: startPosition)
        tour?.delegate = self
        tour?.isRunning = true
        DispatchQueue.global().async {
            _ = self.tour?.compute()
        }
    }
    
    func stopSearch() {
        tour?.isRunning = false
    }
}

extension KTWarnsdorffsAlgorithm: TourComputationDelegate {
    func moveTo(cell: String, count: Int) {
        DispatchQueue.main.async {
            self.presenterView?.didMoveToCell(cell, stepCount: count)
        }
    }
    
    func stepBackTo(cell: String) {
        DispatchQueue.main.async {
            self.presenterView?.goBackToCell(cell)
        }
    }
    
    func finished() {
        DispatchQueue.main.async {
            self.delegate?.searchFinished()
        }
    }
}

// MARK: -

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
        return "abcdefgh"
    }
    
    init?(cellName: String) {
        guard cellName.characters.count == 2 else {
            fatalError("Wrong cell name format! ex. a1")
        }
        guard let letter = cellName.characters.first,
           let letterIndex = Position.alphas.characters.index(of: letter)
            else { fatalError("Failed to retrieve letter") }

        guard let number = cellName.characters.last,
            let y = Int(String(number))
            else { fatalError("Failed to retrieve number") }
        
        let x: Int = Position.alphas.distance(from: Position.alphas.startIndex, to: letterIndex)
        self.init(x: x, y: y - 1)
    }
    
    var stringFormat: String {
        let letter = Position.alphas.characters.map{ String($0) }[x]
        let number = String(y+1)
        return letter + number
    }
}

// MARK: -

fileprivate struct TourComputation {
    private struct Move {
        var position: Position
        var availableNextSteps: [Position]
    }
    
    var boardSize: Int
    var isRunning: Bool = false
    var delegate: TourComputationDelegate?
    
    var visited: Set<Position> = []
    private var path: [Move] = []
    
    init(boardSize: Int, start position: Position) {
        self.boardSize = boardSize
        visited.insert(position)
        path.append(Move(position: position, availableNextSteps: nextStepsWithinTheBoard(from: position)))
    }
    
    // MARK: -
    
    mutating func compute() -> [Position] {
        while path.count != boardSize*boardSize && !path.isEmpty && isRunning {
            let currentMove = path.popLast()!
            let currentPosition = currentMove.position
            let nextSteps = currentMove.availableNextSteps
            
            guard let nextPosition = chooseNextStep(outof: nextSteps) else {
                // no available next steps
                visited.remove(currentPosition)
                //                print("backtracking")
                
                // Displaying step back
                if let previousStep = path.last?.position {
                    sleep(1)
                    delegate?.stepBackTo(cell: previousStep.stringFormat)
                }
                
                continue
            }
            
            remove(nextPosition: nextPosition, from: currentMove)
            makeNextMove(to: nextPosition)
        }
        
        delegate?.finished()
        return path.map { $0.position }
    }
    
    // Warnsdorfss rule - choosing step with less possible next steps
    private func chooseNextStep(outof nextSteps: [Position]) -> Position? {
        if nextSteps.isEmpty { return nil }
        
        var minCount = 8
        var result = nextSteps.first!
        for position in nextSteps {
            let count = nextStepsWithinTheBoard(from: position).filter { !visited.contains($0) }.count
            if count < minCount {
                minCount = count
                result = position
            }
        }
        return result
    }
    
    // remove chosen from nextSteps
    private mutating func remove(nextPosition: Position, from currentMove:Move) {
        let modifiedNextSteps = currentMove.availableNextSteps.filter { $0 != nextPosition }
        
        // have to modify last move's next moves to not repeat
        let modifiedLastMove = Move(position: currentMove.position, availableNextSteps: modifiedNextSteps)
        path.append(modifiedLastMove)
        
        // Displaying move
        sleep(1)
        delegate?.moveTo(cell: nextPosition.stringFormat, count: path.count)
    }
    
    // making the next move
    private mutating func makeNextMove(to nextPosition: Position) {
        visited.insert(nextPosition)
        let availableNextSteps = nextStepsWithinTheBoard(from: nextPosition).filter { !visited.contains($0) }
        let nextMove = Move(position: nextPosition, availableNextSteps: availableNextSteps)
        path.append(nextMove)
    }
    
    // MARK: -
    
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

protocol TourComputationDelegate {
    func moveTo(cell: String, count: Int)
    func stepBackTo(cell: String)
    func finished()
}
