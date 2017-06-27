//
//  KTKnightTourAlgorithm.swift
//  KnightsTour
//
//  Created by Oleg Sher on 26.06.17.
//  Copyright © 2017 OSher. All rights reserved.
//

import Foundation

public protocol KTKnightTourPresenterView {
    var boardSize: Int { get }
    var startCell: String? { get }
    
    func isKnightPresented() -> Bool
    func didMoveToCell(_ cellName: String, stepCount: Int)
    func goBackToCell(_ cellName: String)
    func clearProgress()
}

public protocol KTKnightTourAlgorithmDelegate {
    func searchFinished()
}

public protocol KTKnightTourAlgorithm {
    var isRepeatCellEnabled: Bool { get set }
    var presenterView: KTKnightTourPresenterView? { get set }
    var delegate: KTKnightTourAlgorithmDelegate? { get set }
    
    func runSearch()
    func stopSearch()
}
