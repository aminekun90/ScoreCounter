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
extension ContentView {
    public func removeAllPlayers(){
        players = []
        vibratePhone()
    }
    public func addPlayer() {
        var name:String = "Player \(players.count)"
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
        players.append(newPlayer)
        vibratePhone()
        // Show notification after adding a player
               showNotification(name: name)
        }
    private func showNotification(name: String) {
        let image = UIImageView(image: UIImage(systemName: "gamecontroller.fill"))
        NotificationPresenter.shared.present(name, subtitle: "Added succesfully!",duration: 1)
        NotificationPresenter.shared.displayLeftView(image)
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
        let colors: [Color] = [.red, .green, .blue, .orange, .purple, .yellow, .pink, .teal,.indigo,.brown]
        return colors.randomElement() ?? .blue
    }
   
    public func removePlayer(_ player: Player?) {
        guard let player = player else {
            return
        }

        if let index = players.firstIndex(where: { $0.id == player.id }) {
            players.remove(at: index)
        }
    }
    public func vibratePhone() {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.success) // or use .warning, .error for different vibrations
    }
}
