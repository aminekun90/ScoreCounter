//
//  EditDeckView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 19/03/2024.
//

import Foundation
import SwiftUI

struct EditDeckView: View {
    @Binding var isPresented: Bool
    @Binding var deck: Deck
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Deck Info")) {
                    TextField("Name", text: $deck.name)
                    Stepper("Winning Score: \(deck.winningScore)", value: $deck.winningScore)
                    Toggle("Enable Winning Score", isOn: $deck.enableWinningScore)
                    Toggle("Enable Winning Animation", isOn: $deck.enableWinningAnimation)
                    Toggle("Enable Auto Sort", isOn: $deck.enableScoreAutoSort)
                }
            }
            .navigationTitle("Edit Deck")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    // Perform save action here
                    isPresented = false
                    DeckController.shared.syncDeckList()
                }
            )
        }
    }
}




struct EditDeckView_Previews: PreviewProvider {
    
    @State static var isEditingWinningScore = false
    @State static var deck = Deck()
    static var previews: some View {
        EditDeckView(
            isPresented: $isEditingWinningScore,
            deck: $deck)
    }
}
