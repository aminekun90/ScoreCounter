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


public func  randomEmoji() -> String {
    let emojiRanges: [ClosedRange<UInt32>] = [
        0x1F600...0x1F64F,   // Emoticons
        //0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        //0x1F680...0x1F6FF, // Transport and Map
        //0x1F1E6...0x1F1FF, // Regional country flags
        //0x2600...0x26FF,   // Misc symbols 9728 - 9983
        //0x2700...0x27BF,   // Dingbats
        //0xFE00...0xFE0F,   // Variation Selectors
        //0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs 129280 - 129535
        //0x1F018...0x1F270, // Various asian characters           127000...127600
        //65024...65039,     // Variation selector
        //9100...9300,       // Misc items
        //8400...8447        // other
    ]

    let randomRange = emojiRanges.randomElement()!
    let randomCode = UInt32.random(in: randomRange)
    return String(UnicodeScalar(randomCode)!)
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

