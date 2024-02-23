//
//  PlayerActionsView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//

import SwiftUI

struct PlayerActionsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var deck:Deck
    @Binding var isShowingDialog: Bool
    var addPlayer: (inout Deck) -> Void
    var removeAllPlayers:(inout Deck) -> Void

    var body: some View {
        HStack {
            Button(action: {
                isShowingDialog = true
            }) {
                Image(systemName: "trash")
                    .imageScale(.large)
                    .padding()
                    .foregroundColor(.red)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .disabled(deck.players.isEmpty)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .confirmationDialog("Are you sure to delete all?", isPresented: $isShowingDialog, titleVisibility: .visible) {
                Button("Confirm", role: .destructive) {
                    removeAllPlayers(&deck)
                    
                }
                Button("Cancel", role: .cancel) {}
            }

            Button(action: {
                addPlayer(&deck)
            }) {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .padding()
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
    }
}
