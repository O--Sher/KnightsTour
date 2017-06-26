//
//  KTMainPresenter.swift
//  Knight's Tour
//
//  Created by Oleg Sher on 28.05.17.
//  Copyright © 2017 OSher. All rights reserved.
//

import UIKit

public enum RunState: Int, Equatable {
    case stopped = 0
    case running
    
    var actionTitle: String {
        switch self {
        case .stopped:
            return "Run"
        case .running:
            return "Stop"
        }
    }
    
    func switchState() -> RunState {
        return self == .stopped ? .running : .stopped
    }
    
    public static func ==(lhs: RunState, rhs: RunState) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

// MARK: -

public protocol KTMainPresentationView: class {
    func setBoardSize(_ size: Int)
    func setRepeatModeEnable(_ param: Bool)
    func setRunState(_ state: RunState)
}

public protocol KTMainViewDatasource {
    var boardSize: Int { get set }
    var isRepeatModeEnabled: Bool { get set }
}

// MARK: -

class KTMainPresenter {
    
    // MARK: Vars
    
    weak var presentationView: KTMainPresentationView?
    fileprivate var datasource: KTMainViewDatasource
    
    // MARK: Initializer
    
    init(presentationView: KTMainPresentationView) {
        self.presentationView = presentationView
        self.datasource = KTMainDatasource()
        _setupView()
    }
    
    private func _setupView() {
        guard let presentationView = presentationView else { return }
        presentationView.setBoardSize(datasource.boardSize)
        presentationView.setRepeatModeEnable(datasource.isRepeatModeEnabled)
        presentationView.setRunState(.stopped)
    }
    
    // MARK: Actions
    
    func boardSizeChanged(size: Int) {
        datasource.boardSize = size
        presentationView?.setBoardSize(datasource.boardSize)
    }
    
    func repeatModeChanged(enabled: Bool) {
        datasource.isRepeatModeEnabled = enabled
        presentationView?.setRepeatModeEnable(datasource.isRepeatModeEnabled)
    }
    
    func changeRunState(oldValue: RunState) {
        // FIXME: RUN ALGORYTHM HERE
        let newValue = oldValue.switchState()
        presentationView?.setRunState(newValue)
    }
    
}

