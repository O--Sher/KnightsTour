//
//  KTChessboardCell.swift
//  KnightsTour
//
//  Created by Oleg Sher on 26.06.17.
//  Copyright © 2017 OSher. All rights reserved.
//

import SpriteKit

class KTChessboardCell: SKSpriteNode {
        
    // MARK: - Vars
    
    private var marks: [SKLabelNode] = []
    private var knight: SKSpriteNode?
    
    // MARK: - Actions
    
    func isKnightDisplayed() -> Bool {
        guard let knight = knight else { return false }
        return children.contains(knight)
    }
    
    func showKnight(_ param: Bool) {
        if param {
            if knight == nil {
                let newKnight = SKSpriteNode(imageNamed: "knight")
                let size = self.size.width
                newKnight.size = CGSize(width: size, height: size)
                knight = newKnight
            }
            addChild(knight!)
        } else {
            guard let knight = knight else { return }
            removeChildren(in: [knight])
        }
    }
    
    // MARK: -
    
    func addMark(text: String) {
        let label = SKLabelNode(text: text)
        label.fontColor = .red
        label.fontName = UIFont.boldSystemFont(ofSize: 15).fontName
        label.fontSize = 25
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: 0)
        marks.append(label)
        addChild(label)
    }
    
    func removeLastMark() {
        guard let mark = marks.last else { return }
        removeChildren(in: [mark])
    }
    
    func removeMarks() {
        removeChildren(in: marks)
    }
    
}
