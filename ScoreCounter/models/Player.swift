//
//  Player.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//

import SwiftUI

public struct Player: Identifiable, Equatable {
    public var id = UUID()
    var image:String = "asset-\(Int.random(in: 1...6))"
    var title: String
    var score: Int64
    var color: String
    mutating public func incrementScore(amount:Int64){
        score += amount
    }
}
