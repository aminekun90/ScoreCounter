//
//  settingsView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 23/02/2024.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @Binding var settings: AppSettings

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Picker("Appearance", selection: $settings.appearance) {
                        Text("Dark Mode").tag(AppAppearance.dark)
                        Text("Light Mode").tag(AppAppearance.light)
                        Text("System").tag(AppAppearance.system)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Preferences")) {
                    Toggle("Vibrate Phone", isOn: $settings.vibrate)
                    Toggle("Keep Screen On", isOn: $settings.keepScreenOn)
                }

                Section(header: Text("Score Increments")) {
                    TextField("Increment Value 1", value: $settings.increments[0], formatter: NumberFormatter())
                    TextField("Increment Value 2", value: $settings.increments[1], formatter: NumberFormatter())
                    TextField("Increment Value 3", value: $settings.increments[2], formatter: NumberFormatter())
                }
            }
            .navigationTitle("Settings")
        }
    }
    private func loadSettings() {
           // Use the same logic you have to load settings
           let sqliteService = SqliteService()
           settings = sqliteService.loadAppsettings()
       }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let sqliteService = SqliteService()
        SettingsView(settings: .constant(sqliteService.loadAppsettings()))
    }
}
