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
        // FIXME: Remove
        startTimer()
    }
    
    // MARK: Temporary
    
    var timer: Timer?
    var isDispayed: Bool = false
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameplay), userInfo: nil, repeats: true)
    }
    
    @objc func gameplay() {
        if self.isDispayed {
            self.chessboardScene?.clearObjects()
        } else {
            self.chessboardScene?.simulateLogic()
        }
        self.isDispayed = !self.isDispayed
    }
}

extension KTChessboardViewController: KTChessboardView {
    func drawChessboard(size: Int) {
        chessboardScene?.removeAllChildren()
        chessboardScene?.drawBoard(size: size)
    }
}
