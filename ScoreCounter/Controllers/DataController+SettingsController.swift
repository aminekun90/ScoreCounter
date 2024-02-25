//
//  DataController.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 24/02/2024.
//

import Foundation
class DataController: ObservableObject {
    @Published var appSettings: AppSettings
    
    init() {
        appSettings = SqliteService.sharedSqliteService.loadAppSettings()
    }
    
    func saveSettings() {
        SqliteService.sharedSqliteService.saveAppSettings(appSettings: appSettings)
    }
    
    // Add other data-related functions here
}

class SettingsController: ObservableObject {
    @Published var appSettings: AppSettings
    var dataController: DataController
    static var shared = SettingsController(dataController: DataController())
    
    init(dataController: DataController) {
        self.dataController = dataController
        self.appSettings = dataController.appSettings
    }
    
    func saveSettings() {
        dataController.saveSettings()
    }
    
    // Add other settings-related functions here
}
