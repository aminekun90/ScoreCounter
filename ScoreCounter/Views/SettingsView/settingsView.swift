//
//  settingsView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 23/02/2024.
//

import Foundation
import SwiftUI
struct SettingsView: View {
    @ObservedObject var settingsController: SettingsController = SettingsController.shared
    @State private var showStore = false
    @State private var refreshFlag = false
    var body: some View {
        NavigationView {
            Form{
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
                
                
                ScoreIncrementsSection(
                    increments: $settingsController.appSettings.increments,
                    removeIncrement: { index in
                        settingsController.removeIncrement(at: index)
                    },
                    appendIncrement: { value in
                        settingsController.appendIncrement(value: value)
                    }
                )
                
                Section{
                    Button(action:{
                        showStore.toggle()
                    }){
                        Image("assinat")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 140)
                    }.sheet(isPresented: $showStore, content: {
                        StoreView(isPresented: $showStore)
                    })
                    
                    Text("Score counter Version \(settingsController.appSettings.appVersion)").fontWeight(.light).frame(alignment: .trailing)
                }
            }
            .padding(.bottom,50)
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
        SettingsView()
    }
}
