//
//  DataController.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 24/02/2024.
//
import Foundation
import SpriteKit
import SwiftUI

class DataController: ObservableObject {
    @Published var appSettings: AppSettings
    static var shared = DataController()
    init() {
        appSettings = SqliteService.shared.loadAppSettings()
    }
    
    func saveSettings() {
        SqliteService.shared.saveAppSettings(appSettings: appSettings)
    }
    
    // Add other data-related functions here
}

class SettingsController: ObservableObject {
    @Published var appSettings: AppSettings
    var dataController: DataController
    static var shared = SettingsController(dataController: DataController.shared)
    
    init(dataController: DataController) {
        self.dataController = dataController
        self.appSettings = dataController.appSettings
    }
    
    public func saveSettings() {
        dataController.saveSettings()
    }
    public func getAppearenceColor(shouldBe:Color)->Color{
        let currentTraitCollection = UIScreen.main.traitCollection
        let isDarkMode = currentTraitCollection.userInterfaceStyle == .dark
        if (SettingsController.shared.appSettings.appearance == AppAppearance.light || !isDarkMode){
            return shouldBe == .white ? .black:.white
        }
        return shouldBe
    }
}
