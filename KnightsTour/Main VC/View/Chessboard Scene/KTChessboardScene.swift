//
//  KTChessboardScene.swift
//  KnightsTour
//
//  Created by Oleg Sher on 29.05.17.
//  Copyright © 2017 OSher. All rights reserved.
//

import SpriteKit

class KTChessboardScene: SKScene {
    
    // MARK: Definitions
    
    private static let kCellSize: CGFloat = 35
    private static let alphas = "abcdefgh"
    
    // MARK: View lifecycle
    
    override func didMove(to view: SKView) {
        self.scaleMode = .resizeFill
    }
    
    // MARK: IBActions
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let touchLocation = touch?.location(in: self) else { return }
        for child in children {
            guard let cell = child as? KTChessboardCell else {
                continue
            }
            if child .contains(touchLocation) {
                cell.showKnight(!cell.isKnightDisplayed())
                continue
            }
            cell.showKnight(false)
        }
    }
    
    // MARK: Actions
    
    func drawBoard(size: Int) {
        self.removeAllChildren()
        
        // Board parameters
        let squareSize = KTChessboardScene.kCellSize
        let viewWidth = frame.width
        var toggle:Bool = false // Used to alternate between white and black squares
        
        // Offest to centre
        let sideOffset = (viewWidth - squareSize * CGFloat(size))/2
        let offset:CGFloat = -viewWidth/2 + squareSize/2 + sideOffset
        
        for row in 0...size-1 {
            for col in 0...size-1 {
                let colChar = KTChessboardScene.alphas.characters.map{ String($0) }[col] // Letter for this column
                let color = toggle ? SKColor.white : SKColor.black

                let square = KTChessboardCell(
                    color: color,
                    size: CGSize(width: squareSize, height: squareSize)
                )
                square.position = CGPoint(x: CGFloat(col) * squareSize + offset,
                                          y: CGFloat(row) * squareSize + offset)
                square.name = "\(colChar)\(size-row)" // Set sprite's name (e.g., a8, c5, d1)
                
                self.addChild(square)
                toggle = !toggle
            }
            if size % 2 == 0 { toggle = !toggle } // Check on odd size
        }
        
        _drawIdentifiers(size: size)
    }
    
    func clearBoard() {
        for child in children {
            guard let cell = child as? KTChessboardCell else {
                continue
            }
            cell.showKnight(false)
            cell.removeMark()
        }
    }
    
    // MARK: Private
    
    private func _squareWithName(_ name:String) -> KTChessboardCell? {
        return self.childNode(withName: name) as? KTChessboardCell
    }
    
    private func _drawIdentifiers(size: Int) {
        let squareSize = KTChessboardScene.kCellSize
        
        func labelNode(text: String, position: CGPoint) -> SKLabelNode {
            let label = SKLabelNode(text: text)
            label.color = .white
            label.position = position
            return label
        }
        
        for i in 0..<size {
            
            // Adding letter
            let letter = "\(KTChessboardScene.alphas.characters.map{ String($0) }[i])"
            if let square = _squareWithName("\(letter)1") {
                let identifier = labelNode(
                    text: "\(letter)",
                    position: CGPoint(x: square.position.x,
                                      y: square.position.y + (squareSize / 3) * 2)
                )
                self.addChild(identifier)
            }
            
            // Adding number
            let name = "a\(String(i+1))"
            if let square = _squareWithName(name) {
                let identifier = labelNode(
                    text: "\(i+1)",
                    position: CGPoint(x: square.position.x - squareSize,
                                      y: square.position.y - squareSize / 3)
                )
                self.addChild(identifier)
            }
            
        }
    }
}
