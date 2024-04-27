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
    @Published var textColor:Color = .black
    @Published var backgroundColor:Color = .white
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
        updateScreenOn()
        self.textColor = getAppearenceColor(lightTheme: .white)
        self.backgroundColor = getAppearenceColor(lightTheme: .black)
    }
    private func updateScreenOn() {
        UIApplication.shared.isIdleTimerDisabled = appSettings.keepScreenOn
        }
    public func getAppAppearance() -> ColorScheme {
        switch appSettings.appearance {
        case .dark:
            return .dark
        case .light:
            return .light
        case .system:
            let currentTraitCollection = UIScreen.main.traitCollection
            let isDarkMode = currentTraitCollection.userInterfaceStyle == .dark
            //  let isDarkMode = colorScheme == .dark
            //  print("System isDarkMode \(isDarkMode)")
            
            if(isDarkMode){
                return .dark
            }
            return .light
        }
    }
    
    func removeIncrement(at index: Int) {
        appSettings.increments.values.remove(at: index)
        
        self.saveSettings()
    }
    func appendIncrement(value: Int64) {
        appSettings.increments.values.append(value)
        self.saveSettings()
    }
    public func saveSettings() {
        updateScreenOn()
        dataController.saveSettings()
        
        self.textColor = getAppearenceColor(lightTheme: .white)
        self.backgroundColor = getAppearenceColor(lightTheme: .black)
    }
    
    public func getAppearenceColor(lightTheme:Color)->Color{
        print("lightTheme: \(lightTheme)")
        if (getAppAppearance() == .light){
            return lightTheme == .white ? .black:.white
        }
        return lightTheme
    }
}
