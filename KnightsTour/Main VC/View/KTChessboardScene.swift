//
//  KTChessboardScene.swift
//  KnightsTour
//
//  Created by Oleg Sher on 29.05.17.
//  Copyright © 2017 OSher. All rights reserved.
//

import SpriteKit
import GameplayKit

class KTChessboardScene: SKScene {
    
    override func didMove(to view: SKView) {
        self.scaleMode = .resizeFill
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let touchLocation = touch?.location(in: self) {
            for child in children {
                if let childView = child as? SKSpriteNode,
                    child .contains(touchLocation) {
                        
                    let newSize = childView.size.width * 0.75
                    let mark = SKSpriteNode(color: .yellow, size: CGSize(width: newSize, height: newSize))
                    mark.position = CGPoint(x: 0,
                                            y: 0)
                    childView.addChild(mark)
                }
            }
        }
    }
    
    func simulateLogic() {
        if let square = squareWithName("b7") {
            let gamePiece = SKSpriteNode(imageNamed: "Spaceship")
            gamePiece.size = CGSize(width: 24, height: 24)
            square.addChild(gamePiece)
        }
        if let square = squareWithName("e3") {
            let newSize = square.size.width * 0.75
            let mark = SKSpriteNode(color: .red, size: CGSize(width: newSize, height: newSize))
            mark.position = CGPoint(x: 0,
                                    y: 0)
            square.addChild(mark)
        }
    }
    
    func clearObjects() {
        if let square = squareWithName("b7") {
            square.removeAllChildren()
        }
        if let square = squareWithName("e3") {
            square.removeAllChildren()
        }
    }
    
    func drawBoard(size: Int) {
        // Board parameters
        let numRows = size
        let numCols = size
        let squareSize = CGSize(width: 35, height: 35)
        let screenWidth = UIScreen.main.bounds.width
        let sideOffset = (screenWidth - squareSize.width * CGFloat(numCols))/2
        let xOffset:CGFloat = -screenWidth/2 + squareSize.width/2 + sideOffset
        let yOffset:CGFloat = xOffset
        // Column characters
        let alphas:String = "abcdefgh"
        // Used to alternate between white and black squares
        var toggle:Bool = false
        for row in 0...numRows-1 {
            for col in 0...numCols-1 {
                // Letter for this column
                let colChar = alphas.characters.map{ String($0) }[col]
                // Determine the color of square
                let color = toggle ? SKColor.white : SKColor.black
                let square = SKSpriteNode(color: color, size: squareSize)
                square.position = CGPoint(x: CGFloat(col) * squareSize.width + xOffset,
                                              y: CGFloat(row) * squareSize.height + yOffset)
                // Set sprite's name (e.g., a8, c5, d1)
                square.name = "\(colChar)\(numCols-row)"
                self.addChild(square)
                toggle = !toggle
            }
            if size % 2 == 0 {
                toggle = !toggle
            }
        }
        for col in 0..<numCols {
            let letter = "\(alphas.characters.map{ String($0) }[col])"
            if let square = squareWithName("\(letter)1") {
                let name = SKLabelNode(text: "\(letter)")
                name.color = .white
                name.position = CGPoint(x: square.position.x,
                                        y: square.position.y + (squareSize.height / 3) * 2)
                self.addChild(name)
            }
        }
        for row in 0..<numRows {
            let name = "a\(String(row+1))"
            if let square = squareWithName(name) {
                let name = SKLabelNode(text: "\(row+1)")
                name.color = .white
                name.position = CGPoint(x: square.position.x - squareSize.width,
                                        y: square.position.y - squareSize.height / 3)
                self.addChild(name)
            }
        }
    }
    
    private func squareWithName(_ name:String) -> SKSpriteNode? {
        return self.childNode(withName: name) as? SKSpriteNode
    }
}
