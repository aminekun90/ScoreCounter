//
//  PlayerActionsView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//

import SwiftUI
struct DeleteAllButton: View {
    @Binding var isShowingDialog: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            isShowingDialog = true
        }) {
            Text("Delete All").foregroundColor(.red)
            Image(systemName: "trash.fill")
                .imageScale(.large)
                .padding()
                .foregroundColor(.red)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .disabled(false) // You can dynamically set this based on your condition
        .confirmationDialog("Are you sure to delete all?", isPresented: $isShowingDialog, titleVisibility: .visible) {
            Button("Confirm", role: .destructive) {
                action()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
struct PlayerActionsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var deck:Deck
    @Binding var isShowingDialog: Bool
    var addPlayer: (inout Deck) -> Void
    var removeAllPlayers:(inout Deck) -> Void
    var changeWinningLogic:(inout Deck) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    changeWinningLogic(&deck)
                }) {
                    Image(systemName: "party.popper")
                        .imageScale(.large)
                        .padding()
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                // Destructure the tuple returned by getWinnerName
                let (winnerImage, winnerText) = deck.getWinnerName()
                
                if let image = winnerImage {
                    Image(systemName: image)
                        .imageScale(.large)
                        .padding()
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                
                Text(winnerText)
                Spacer()
                Button(action: {
                    addPlayer(&deck)
                }) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .padding()
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                Menu {
                    Button(role: .destructive) {
                        print("I was called... and that's it")
                        isShowingDialog = true
                    }
                label: {
                    Label("Delete All", systemImage: "trash")
                }.disabled(deck.players.isEmpty)
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                        .padding()
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }.confirmationDialog(
                    "Are you sure?",
                    isPresented: $isShowingDialog,
                    titleVisibility: .visible
                ) {
                    Button("Yes", role: .destructive) {
                        
                        removeAllPlayers(&deck)
                        print("Remove all players")
                    }
                    
                    Button("Cancel", role: .cancel) {}
                }
            }
            .background(Color.blue) // Set your preferred background color
            .foregroundColor(.white) // Set your preferred text color
            Spacer()
        }
        
    }
}

struct PlayerActionsView_Previews: PreviewProvider {
    @State static var deck = Deck()
    @State static var isShowingDialog = false
    
    static var previews: some View {
        PlayerActionsView(
            deck: $deck,
            isShowingDialog: $isShowingDialog,
            addPlayer: { _ in },
            removeAllPlayers: { _ in },
            changeWinningLogic: { _ in }
        )
    }
}
