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

//extension UUID: Equatable {
//    public static func == (lhs: UUID, rhs: UUID) -> Bool {
//        return lhs.uuidString == rhs.uuidString
//    }
//}

public struct Deck:Identifiable {
    public var id = UUID()
    var name:String = UUID().uuidString
    var winningScore:Int = 42
    var increment:Int = 1
    var enableWinningScore:Bool = true
    var enableWinningAnimation:Bool = true
    var players:[Player] = []
    var winingLogic:WinningLogic = WinningLogic.normal
    
    mutating public func resetAllScores() {
        for index in self.players.indices {
            self.players[index].score = 0
        }
    }
    
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
    
    mutating public func changeWinningLogic() {
        self.winingLogic = (self.winingLogic == .normal) ? .inverted : .normal
        showNotification(name: "Winning logic", subtitle: "changed", icon:UIImage(systemName: "medal")!)
    }
    mutating public func removePlayer(_ player: Player?) {
        guard let player = player else {
            return
        }
        
        if let index = self.players.firstIndex(where: { $0.id == player.id }) {
            self.players.remove(at: index)
            vibratePhone()
        }
    }
    mutating public func removeAllPlayers(){
        self.players = []
        vibratePhone()
    }
    mutating public func addPlayer() {
        var name:String = "Player \(self.players.count)"
        if let listData = loadListFromJSON() {
            // Access the list of strings
            let items = listData.items
            if let randomItem = items.randomElement() {
                print("Randomly selected item: \(randomItem)")
                name = String(randomItem)
            } else {
                print("List is empty.")
            }
        } else {
            print("Failed to load JSON data.")
        }
        let newPlayer = Player(title: name, score: 0, color: getRandomColor())
        self.players.append(newPlayer)
        vibratePhone()
        // Show notification after adding a player
        showNotification(name: name,subtitle: "Added succesfully!",icon:UIImage(systemName: "gamecontroller.fill")!)
    }
    mutating public func updateScore(_ playerId: UUID, increment: Bool, amount: Int? = 1) {
        if let playerIndex = self.players.firstIndex(where: { $0.id == playerId }) {
            let delta = (increment ? 1 : -1) * (amount ?? self.increment)
            self.players[playerIndex].incrementScore(amount: delta)
            vibratePhone()
        }
    }
}
