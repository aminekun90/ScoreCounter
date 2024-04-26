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

}
