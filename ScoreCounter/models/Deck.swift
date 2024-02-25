//
//  Deck.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 23/02/2024.
//

import Foundation
import SwiftUI
public enum WinningLogic {
    case normal
    case inverted
}
public struct Deck {
    var name:String = UUID().uuidString
    var winningScore:Int = 42
    var increment:Int = 1
    var enableWinningScore:Bool = true
    var enableWinningAnimation:Bool = true
    var players:[Player] = []
    var winingLogic:WinningLogic = WinningLogic.normal
    public func getWinnerName() -> (String?, String) {
        guard players.count > 1 else {
            // Not enough players to determine a winner
            return (nil, "")
        }

        let sortedPlayers: [Player]
        if self.winingLogic == .normal {
            sortedPlayers = players.sorted { $0.score > $1.score }
        } else {
            sortedPlayers = players.sorted { $0.score < $1.score }
        }

        let maxScore = sortedPlayers[0].score
        let winners = sortedPlayers.filter { $0.score == maxScore }

        if winners.count > 1 {
            // Multiple players with the same highest (or lowest) score
            return (nil, "\(winners.count)")
        } else {
            // Only one player with the highest (or lowest) score
            if players.count > 1 {
                let winnerImage = winners.isEmpty ? nil : "medal"
                let winnerText = winners.isEmpty ? "" : winners.first!.title
                return (winnerImage, winnerText)
            }

            return (nil, "")
        }
    }
}
