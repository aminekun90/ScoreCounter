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



public func showNotification(name: String,subtitle:String,icon:UIImage?) {
    let image = icon != nil ? UIImageView(image: icon):nil
    NotificationPresenter.shared.present(name, subtitle: subtitle,duration:1)
    if (image != nil) {
        NotificationPresenter.shared.displayLeftView(image)
    }
}
func loadListFromJSON() -> ListData? {
    guard let url = Bundle.main.url(forResource: "names", withExtension: "json") else {
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

public func getRandomColor() -> Color {
    let randomRed = Double.random(in: 0.0...1.0)
    let randomGreen = Double.random(in: 0.0...1.0)
    let randomBlue = Double.random(in: 0.0...1.0)

    return Color(red: randomRed, green: randomGreen, blue: randomBlue)
}

public func vibratePhone() {
    if(SettingsController.shared.appSettings.vibrate){
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.success) // or use .warning, .error for different vibrations
    }
}

