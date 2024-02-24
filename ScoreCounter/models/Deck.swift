//
//  Deck.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 23/02/2024.
//

import Foundation
import SwiftUI
public struct Deck {
    var name:String = UUID().uuidString
    var winningScore:Int = 42
    var increment:Int = 1
    var enableWinningScore:Bool = true
    var enableWinningAnimation:Bool = true
    var players:[Player] = []
}