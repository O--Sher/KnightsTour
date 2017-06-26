//
//  KTChessboardCell.swift
//  KnightsTour
//
//  Created by Oleg Sher on 26.06.17.
//  Copyright © 2017 OSher. All rights reserved.
//

import SpriteKit

class KTChessboardCell: SKSpriteNode {
    
    // MARK: - Definitions
    
    private static let kKnightSize: CGFloat = 50
    private static let kMarkSize: CGFloat = 35
    
    // MARK: - Vars
    
    private var marks: [SKLabelNode] = []
    
    private var knight: SKSpriteNode = {
        let knight = SKSpriteNode(imageNamed: "knight")
        let size = KTChessboardCell.kKnightSize
        knight.size = CGSize(width: size, height: size)
        return knight
    }()
    
    // MARK: - Actions
    
    func isKnightDisplayed() -> Bool {
        return children.contains(knight)
    }
    
    func showKnight(_ param: Bool) {
        if param {
            addChild(knight)
        } else {
            removeChildren(in: [knight])
        }
    }
    
    // MARK: -
    
    func addMark(text: String) {
        let label = SKLabelNode(text: text)
        label.fontColor = .red
        label.fontName = UIFont.boldSystemFont(ofSize: 17).fontName
        label.position = CGPoint(x: 0, y: 0 - size.height / 3)
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
