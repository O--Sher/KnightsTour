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
    
    private var mark: SKLabelNode?
    
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
    
    func isMarkDisplayed() -> Bool {
        guard let mark = mark else { return false }
        return children.contains(mark)
    }
    
    func addMark(text: String) {
        let label = SKLabelNode(text: text)
        label.fontColor = .red
        label.fontName = UIFont.boldSystemFont(ofSize: 17).fontName
        label.position = CGPoint(x: 0, y: 0 - size.height / 3)
        mark = label
        addChild(label)
    }
    
    func removeMark() {
        guard let mark = mark else { return }
        removeChildren(in: [mark])
    }
    
}
