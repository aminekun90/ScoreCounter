//
//  Player.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//

import SwiftUI

struct Player: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var score: Int
    var color: Color
}
