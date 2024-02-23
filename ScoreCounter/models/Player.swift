//
//  Player.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//

import SwiftUI

public struct Player: Identifiable, Equatable {
    public var id = UUID()
    var title: String
    var score: Int
    var color: Color
}
