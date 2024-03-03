//
//  Deck.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 23/02/2024.
//

import Foundation
import SwiftUI
import SQLite

public enum WinningLogic:String {
    case normal
    case inverted
}


extension WinningLogic: Value {
    public static var declaredDatatype: String {
        return String.declaredDatatype
    }
    
    public static func fromDatatypeValue(_ datatypeValue: String) -> WinningLogic {
        return WinningLogic(rawValue: datatypeValue) ?? .inverted
    }
    
    public var datatypeValue: String {
        return rawValue
    }
}



public class Deck:Identifiable {
    public var id = UUID()
    var name:String = UUID().uuidString
    var winningScore:Int = 42
    var increment:Int64 = 1
    var enableWinningScore:Bool = true
    var enableWinningAnimation:Bool = true
    var players:[Player] = []
    var winingLogic:WinningLogic = WinningLogic.normal
    
    init(
        id:UUID = UUID(),
        name: String = UUID().uuidString,
        winningScore: Int = 42,
        increment: Int64 = 1,
        enableWinningScore: Bool = true,
        enableWinningAnimation: Bool = true,
        winingLogic: WinningLogic = WinningLogic.normal){
            self.id=id
            self.name=name
            self.winningScore = winningScore
            self.increment=increment
            self.enableWinningScore = enableWinningScore
            self.enableWinningAnimation = enableWinningAnimation
    }
    
    public func resetAllScores() {
        for index in self.players.indices {
            self.players[index].score = 0
        }
    }
    
    public func getWinnerName() -> (Bool, String) {
        guard players.count > 1 else {
            // Not enough players to determine a winner
            return (false, "")
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
            return (false, "\(winners.count)")
        } else {
            // Only one player with the highest (or lowest) score
            if players.count > 1 {
                let winnerText = winners.isEmpty ? "" : winners.first!.title
                return (true, winnerText)
            }
            
            return (false, "")
        }
    }
    
    public func changeWinningLogic() {
        self.winingLogic = (self.winingLogic == .normal) ? .inverted : .normal
        showNotification(name: "Winning logic", subtitle: "changed", icon:UIImage(systemName: "medal")!)
    }
    public func removePlayer(_ player: Player?) {
        guard let player = player else {
            return
        }
        
        if let index = self.players.firstIndex(where: { $0.id == player.id }) {
            self.players.remove(at: index)
            vibratePhone()
        }
    }
    public func removeAllPlayers(){
        self.players = []
        vibratePhone()
    }
    public func addPlayer() {
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
        let newPlayer = Player(title: name, score: 0, color: getRandomColor(),order:self.players.last?.order ?? 0)
        self.players.append(newPlayer)
        vibratePhone()
        // Show notification after adding a player
        showNotification(name: name,subtitle: "Added succesfully!",icon:UIImage(systemName: "gamecontroller.fill")!)
    }

    public func sortPlayersByOrder() {
        print("Sorting players by order")
        players.sort { (player1:Player, player2:Player) -> Bool in
            return player1.order < player2.order
        }
    }

    public func syncPlayersOrderToIndex(){
        print("Sync players order to position...")
        for (index, player) in players.enumerated() {
            player.order = index + 1
        }
    }
    public func updateScore(_ playerId: UUID, increment: Bool, amount: Int64? = 1) {
        if let playerIndex = self.players.firstIndex(where: { $0.id == playerId }) {
            let delta = (increment ? 1 : -1) * (amount ?? self.increment)
            self.players[playerIndex].incrementScore(amount: delta)
            vibratePhone()
        }
    }
}
