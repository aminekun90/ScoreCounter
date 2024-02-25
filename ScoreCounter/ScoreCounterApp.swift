//
//  ScoreCounterApp.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//

import SwiftUI
import UIKit
@main
struct ScoreCounterApp: App {
    @StateObject private var settingsController = SettingsController.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some Scene {
        WindowGroup {
            // Pass the shared instances to the ContentView
            ContentView()
                .environmentObject(settingsController)
                .preferredColorScheme(getAppAppearance())
                
        }
    }
    
    private func getAppAppearance() -> ColorScheme {
        switch settingsController.appSettings.appearance {
        case .dark:
            return .dark
        case .light:
            return .light
        case .system:
            let currentTraitCollection = UIScreen.main.traitCollection
            let isDarkMode = currentTraitCollection.userInterfaceStyle == .dark
            print("System isDarkMode \(isDarkMode)")
            if(isDarkMode){
                return .dark
            }
            return .light
        }
    }
}
