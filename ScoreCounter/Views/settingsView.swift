//
//  settingsView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 23/02/2024.
//

import Foundation
import SwiftUI
struct SettingsView: View {
    @ObservedObject var settingsController: SettingsController
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Picker("Appearance", selection: $settingsController.appSettings.appearance) {
                        Text("Dark Mode").tag(AppAppearance.dark)
                        Text("Light Mode").tag(AppAppearance.light)
                        Text("System").tag(AppAppearance.system)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Preferences")) {
                    Toggle("Vibrate Phone", isOn: $settingsController.appSettings.vibrate)
                    Toggle("Keep Screen On", isOn: $settingsController.appSettings.keepScreenOn)
                }
                
                Section(header: Text("Score Increments")) {
                    TextField("Increment Value 1", value: $settingsController.appSettings.increments.values[0], formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    TextField("Increment Value 2", value: $settingsController.appSettings.increments.values[1], formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    TextField("Increment Value 3", value: $settingsController.appSettings.increments.values[2], formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button(action: {
                saveSettings()
                showNotification(name: "Setttings", subtitle: "Saved successfully!",icon:UIImage(systemName: "gear"))
            }) {
                HStack{
                    Text("Save")
                    Image(systemName: "square.and.arrow.down.fill")
                        .imageScale(.large)
                }
                
            })
        }
    }
    
    private func saveSettings() {
        settingsController.saveSettings()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
         let dataController = DataController()
         let settingsController = SettingsController(dataController: dataController)
        SettingsView(settingsController: settingsController)
    }
}
