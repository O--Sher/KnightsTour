//
//  KTMainViewController.swift
//  Knight's Tour
//
//  Created by Oleg Sher on 28.05.17.
//  Copyright © 2017 OSher. All rights reserved.
//

import UIKit

public protocol KTChessboardView {
    var knightTourPresenterView: KTKnightTourPresenterView? { get }
    func drawChessboard(size: Int)
    func clearBoard()
}

// MARK: -

class KTMainViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet fileprivate weak var chessboardContainerView: UIView!
    @IBOutlet fileprivate weak var sizeLabel: UILabel!
    @IBOutlet fileprivate weak var sizeStepper: UIStepper!
    @IBOutlet fileprivate weak var repeatSwitch: UISwitch!
    @IBOutlet fileprivate weak var actionButton: UIButton!
    
    // MARK: Vars
    
    fileprivate var presenter: KTMainPresenter!
    fileprivate var chessboardView: KTChessboardView?

    // MARK: View lifecycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupChessboardView()
        presenter = KTMainPresenter(presentationView: self)
    }
    
    // MARK: IBActions
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        presenter.boardSizeChanged(size: Int(sender.value))
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        presenter.repeatModeChanged(enabled: sender.isOn)
    }

    @IBAction func action(_ sender: UIButton) {
        guard let currentState = RunState(rawValue: sender.tag) else {
            fatalError("Failed to retrieve tag state from button")
        }
        presenter.changeRunState(oldValue: currentState)
    }
    
    @IBAction func clearAction(_ sender: Any) {
        chessboardView?.clearBoard()
    }
    
    // MARK: Private
    
    private func _setupChessboardView() {
        let chessboard = KTChessboardViewController()
        self.chessboardView = chessboard as KTChessboardView
        self.embedViewController(chessboard, inView: chessboardContainerView)
    }
}

// MARK: - KTMainPresentationView
extension KTMainViewController: KTMainPresentationView {
    var knightTourPresenterView: KTKnightTourPresenterView? {
        return chessboardView?.knightTourPresenterView
    }

    func setBoardSize(_ size: Int) {
        sizeLabel.text = "\(size)x\(size)"
        sizeStepper.value = Double(size)
        chessboardView?.drawChessboard(size: size)
    }
    
    func setRepeatModeEnable(_ param: Bool) {
        repeatSwitch.isOn = param
    }
    
    func setRunState(_ state: RunState) {
        actionButton.setTitle(state.actionTitle, for: .normal)
        actionButton.tag = state.rawValue
    }
}

