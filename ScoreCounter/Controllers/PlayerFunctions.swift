//
//  PlayerFunctions.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//
import Foundation
import SwiftUI
import UIKit
import JDStatusBarNotification
struct ListData: Codable {
    var items: [String]
}

public func removeAllPlayers(deck: inout Deck){
    deck.players = []
    vibratePhone()
}
public func addPlayer(deck: inout Deck) {
    var name:String = "Player \(deck.players.count)"
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
    deck.players.append(newPlayer)
    vibratePhone()
    // Show notification after adding a player
    showNotification(name: name,subtitle: "Added succesfully!",icon:UIImage(systemName: "gamecontroller.fill")!)
}
public func showNotification(name: String,subtitle:String,icon:UIImage?) {
    let image = icon != nil ? UIImageView(image: icon):nil
    NotificationPresenter.shared.present(name, subtitle: subtitle,duration:1)
    if (image != nil) {
        NotificationPresenter.shared.displayLeftView(image)
    }
}
func loadListFromJSON() -> ListData? {
    guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
        print("File not Found")
        return nil // File not found
    }
    
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let listData = try decoder.decode([String].self, from: data)
        return ListData(items: listData)
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}

public func updateScore(deck: inout Deck,_ playerId: UUID, increment: Bool, amount: Int? = 1) {
    if let playerIndex = deck.players.firstIndex(where: { $0.id == playerId }) {
        if increment {
            deck.players[playerIndex].score += amount ?? deck.increment
        } else {
            deck.players[playerIndex].score -= amount ?? deck.increment
        }
        vibratePhone()
    }
}

public func getRandomColor() -> Color {
    let colors: [Color] = [.red, .green, .blue, .orange, .purple, .yellow, .pink, .teal,.indigo,.brown]
    return colors.randomElement() ?? .blue
}

public func removePlayer(deck: inout Deck,_ player: Player?) {
    guard let player = player else {
        return
    }
    
    if let index = deck.players.firstIndex(where: { $0.id == player.id }) {
        deck.players.remove(at: index)
        vibratePhone()
    }
}
public func vibratePhone() {
    if(SettingsController.shared.appSettings.vibrate){
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.success) // or use .warning, .error for different vibrations
    }
}

public func changeWinningLogic(deck: inout Deck) {
    deck.winingLogic = (deck.winingLogic == .normal) ? .inverted : .normal
    showNotification(name: "Winning logic", subtitle: "changed", icon:UIImage(systemName: "medal")!)
}
