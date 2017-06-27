//
//  KTMainDatasource.swift
//  Knight's Tour
//
//  Created by Oleg Sher on 28.05.17.
//  Copyright © 2017 OSher. All rights reserved.
//

import Foundation

class KTMainDatasource: KTMainViewDatasource {
    
    // MARK: Definitions
    
    private static let kDefaultBoardSize = 5
    private static let kDefaultBoardSizeRange = 5...15
    
    private static let kBoardSizeKey = "KTBoardSize"
    private static let kRepeatModeKey = "KTRepeatMode"
    
    // MARK: Vars
    
    var searchAlgorithm: KTKnightTourAlgorithm = KTWarnsdorffsAlgorithm()
    
    var boardSize: Int {
        get {
            let size = UserDefaults.standard.integer(forKey: KTMainDatasource.kBoardSizeKey)
            if size == 0 {
                self.boardSize = KTMainDatasource.kDefaultBoardSize
                return KTMainDatasource.kDefaultBoardSize
            } else {
                return size
            }
        }
        set {
            if KTMainDatasource.kDefaultBoardSizeRange ~= newValue {
                UserDefaults.standard.set(newValue, forKey: KTMainDatasource.kBoardSizeKey)
            } else {
                fatalError("Chessboard size: '\(newValue)' should be in range of: \(KTMainDatasource.kDefaultBoardSizeRange)")
            }
        }
    }
    
    var isRepeatModeEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: KTMainDatasource.kRepeatModeKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KTMainDatasource.kRepeatModeKey)
        }
    }
    
}
