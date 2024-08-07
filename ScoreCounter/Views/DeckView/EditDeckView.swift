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
    
    @State private var winningScore: Int
    @State private var increment: Int64
    @State private var enableWinningScore: Bool
    @State private var enableWinningAnimation: Bool
    @State private var enableScoreAutoSort: Bool
    
    init(isPresented: Binding<Bool>, deck: Binding<Deck>) {
        self._isPresented = isPresented
        self._deck = deck
        self._winningScore = State(initialValue: deck.wrappedValue.winningScore)
        self._increment = State(initialValue: deck.wrappedValue.increment)
        self._enableWinningScore = State(initialValue: deck.wrappedValue.enableWinningScore)
        self._enableWinningAnimation = State(initialValue: deck.wrappedValue.enableWinningAnimation)
        self._enableScoreAutoSort = State(initialValue: deck.wrappedValue.enableScoreAutoSort)
         }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Deck Info")) {
                    TextField("Name", text: $deck.name)
                    Stepper("Winning Score: \(winningScore)", value: $winningScore)
                    Stepper("Increment: \(increment)", value: $increment)
                    Toggle("Enable Winning Score", isOn: $enableWinningScore.animation())
                    Toggle("Enable Winning Animation", isOn: $enableWinningAnimation.animation())
                    Toggle("Enable Auto Sort", isOn: $enableScoreAutoSort.animation())
                }
            }
            .navigationTitle("Edit Deck")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    // Perform save action here
                    deck.winningScore = winningScore
                    deck.increment = increment
                    deck.enableWinningScore = enableWinningScore
                    deck.enableWinningAnimation = enableWinningAnimation
                    deck.enableScoreAutoSort = enableScoreAutoSort
                    isPresented = false
                    DeckController.shared.syncDeckList()
                }
            )
        }
    }
}

struct EditDeckView_Previews: PreviewProvider {
    @State static var isPresented = false
    @State static var deck = Deck()
    
    static var previews: some View {
        EditDeckView(
            isPresented: $isPresented,
            deck: $deck)
    }
}
