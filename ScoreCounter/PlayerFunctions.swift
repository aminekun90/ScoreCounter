//
//  PlayerFunctions.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//

import SwiftUI
import UIKit
extension ContentView {
    public func removeAllPlayers(){
        players = []
        vibratePhone()
    }
    public func addPlayer() {
        let newPlayer = Player(title: "Player \(players.count + 1)", score: 0, color: getRandomColor())
        players.append(newPlayer)
        vibratePhone()
    }

    public func updateScore(_ playerId: UUID, increment: Bool, amount: Int? = 1) {
        if let playerIndex = players.firstIndex(where: { $0.id == playerId }) {
            if increment {
                players[playerIndex].score += amount ?? 1
            } else {
                players[playerIndex].score -= amount ?? 1
            }
            vibratePhone()
        }
    }

    public func getRandomColor() -> Color {
        let colors: [Color] = [.red, .green, .blue, .orange, .purple, .yellow, .pink, .teal]
        return colors.randomElement() ?? .blue
    }
   
    public func removePlayer(_ player: Player) {
           if let index = players.firstIndex(of: player) {
               players.remove(at: index)
           }
       }
    public func vibratePhone() {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.success) // or use .warning, .error for different vibrations
    }
}
