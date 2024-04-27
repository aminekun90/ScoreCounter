//
//  DiceRepresentationModel.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 24/02/2024.
//

import Foundation

struct DiceRepresentationModel {
    let rows: [[Int]]
    let side :DiceSide
    init(diceSide side: DiceSide) {
        self.side = side
        switch side {
        case .one:
            rows = [[0, 0, 0], [0, 1, 0], [0, 0, 0]]
        case .two:
            rows = [[1, 0, 0], [0, 0, 0], [0, 0, 1]]
        case .three:
            rows = [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
        case .four:
            rows = [[1, 0, 1], [0, 0, 0], [1, 0, 1]]
        case .five:
            rows = [[1, 0, 1], [0, 1, 0], [1, 0, 1]]
        case .six:
            rows = [[1, 0, 1], [1, 0, 1], [1, 0, 1]]
        }
    }
    func getSideValue() -> Int{
        switch self.side {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        case .four:
            return 4
        case .five:
            return 5
        case .six:
            return 6
        }
    }

}
