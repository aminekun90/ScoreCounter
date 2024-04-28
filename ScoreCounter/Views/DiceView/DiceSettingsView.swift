//
//  DiceSettingsView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 28/04/2024.
//

import SwiftUI

struct DiceSettingsView: View {
    @Binding var isPresented: Bool
    @State var numberOfDices:Int = 1
    @State var enableShakeToRoll: Bool = true
    @State var enableSound: Bool = true
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Settings")) {
                    
                    Toggle("Shake to roll", isOn: $enableShakeToRoll)
                    Toggle("Play sound", isOn: $enableSound)
                }
            }
            .navigationTitle("Edit Dice")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                
                trailing: Button("Save") {
                    //Todo: add database save
                    isPresented = false
                    
                }
            )
        }
    }
}


struct DiceSettingsView_Previews: PreviewProvider {
    @State static var presented = true
    static var previews: some View {
        DiceSettingsView(isPresented: $presented)
    }
}
