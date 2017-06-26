//
//  KTSampleAlgorithm.swift
//  KnightsTour
//
//  Created by Oleg Sher on 26.06.17.
//  Copyright © 2017 OSher. All rights reserved.
//

import Foundation

class KTSampleAlgorithm: KTKnightTourAlgorithm {
    var isRepeatCellEnabled: Bool = false
    var presenterView: KTKnightTourPresenterView?
    var delegate: KTKnightTourAlgorithmDelegate?
    
    func runSearch() {
        presenterView?.clearProgress()
        DispatchQueue.global().async {
            let cells = ["a5", "b3", "e4", "d2", "a3"]
            for i in 0..<cells.count {
                sleep(1)
                self.moveTo(cell: cells[i], count: i+1)
                if i == cells.count - 1 {
                    sleep(1)
                    self.stepBackTo(cell: "d2")
                }
            }
        }
    }
    
    func stopSearch() {
        print("Stopping...")
    }
    
    private func moveTo(cell: String, count: Int) {
        DispatchQueue.main.async {
            self.presenterView?.didMoveToCell(cell, stepCount: count)
        }
    }
    
    private func stepBackTo(cell: String) {
        DispatchQueue.main.async {
            self.presenterView?.goBackToCell(cell)
            self.delegate?.searchFinished()
        }
    }
}
