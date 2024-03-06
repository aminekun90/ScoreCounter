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
    public var sqliteService = SqliteService.shared
    init() {
        appSettings = SqliteService.shared.loadAppSettings()
    }
    
    func saveSettings() {
        sqliteService.saveAppSettings(appSettings: appSettings)
    }
    
    // Add other data-related functions here
}

class SettingsController: ObservableObject {
    @Published var appSettings: AppSettings{
        willSet {
            objectWillChange.send()
        }
    }
    var dataController: DataController
    static var shared = SettingsController(dataController: DataController.shared)
    
    init(dataController: DataController) {
        self.dataController = dataController
        self.appSettings = dataController.appSettings
    }
    func removeIncrement(at index: Int) {
        appSettings.increments.values.remove(at: index)
        self.saveSettings()
        objectWillChange.send()
    }
    func appendIncrement(value: Int64) {
        appSettings.increments.values.append(value)
        self.saveSettings()
        objectWillChange.send()
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
