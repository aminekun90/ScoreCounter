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
    var body: some Scene {
        WindowGroup {
            // Pass the shared instances to the ContentView
            ContentView()
                .environmentObject(settingsController)
                .preferredColorScheme(settingsController.getAppAppearance())
                
        }
    }
}
