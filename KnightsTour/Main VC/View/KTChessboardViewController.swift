//
//  KTChessboardViewController.swift
//  KnightsTour
//
//  Created by Oleg Sher on 29.05.17.
//  Copyright © 2017 OSher. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class KTChessboardViewController: UIViewController {
    
    // MARK: Vars

    fileprivate var chessboardScene: KTChessboardScene?

    // MARK: View lifecycle
    
    override func loadView() {
        view = SKView()
        view.backgroundColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "KTChessboardScene") as? KTChessboardScene {
                scene.scaleMode = .aspectFill
                chessboardScene = scene
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

extension KTChessboardViewController: KTChessboardView {
    func drawChessboard(size: Int) {
        chessboardScene?.drawBoard(size: size)
    }
    func clearBoard() {
        chessboardScene?.clearBoard()
    }
}
