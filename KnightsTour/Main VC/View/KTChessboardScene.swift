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
        drawBoard()
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
            mark.color = .red
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
    
    private func drawBoard() {
        // Board parameters
        let numRows = 8
        let numCols = 8
        let squareSize = CGSize(width: 35, height: 35)
        let screenWidth = UIScreen.main.bounds.width
        let xOffset:CGFloat = -screenWidth/2 + squareSize.width / 2 + (screenWidth - squareSize.width * 8)/2
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
                square.name = "\(colChar)\(8-row)"
                self.addChild(square)
                toggle = !toggle
            }
            toggle = !toggle
        }
//        for col in 0..<numCols {
//            let letter = "\(alphas.characters.map{ String($0) }[col])"
//            if let square = squareWithName("\(letter)1") {
//                let name = SKLabelNode(text: "\(letter)")
//                name.color = .white
//                name.position = CGPoint(x: square.position.x,
//                                        y: square.position.y + squareSize.height)
//                self.addChild(name)
//            }
//        }
//        for row in 0..<numRows {
//            let name = "a\(String(row+1))"
//            if let square = squareWithName(name) {
//                let name = SKLabelNode(text: "\(row+1)")
//                name.color = .white
//                name.position = CGPoint(x: square.position.x - squareSize.width,
//                                        y: square.position.y - squareSize.height / 3)
//                self.addChild(name)
//            }
//        }
    }
    
    private func squareWithName(_ name:String) -> SKSpriteNode? {
        let square:SKSpriteNode? = self.childNode(withName: name) as! SKSpriteNode?
        return square
    }
}
