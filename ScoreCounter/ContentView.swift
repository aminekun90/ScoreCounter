//
//  ContentView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//

import SwiftUI

struct ContentView: View {
    @State var deck = Deck()
    @State private var selectedPlayer: Player? = nil
    let horizontalMargin: CGFloat = 10
    @State private var isShowingDialog = false
    let sqliteService = SqliteService()

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 10) {
                        PlayerActionsView(players: $deck.players, isShowingDialog: $isShowingDialog, addPlayer: addPlayer, removeAllPlayers: removeAllPlayers)
                        if deck.players.isEmpty {
                            LandingPageView(addPlayer: addPlayer)
                        }
                        ForEach(deck.players) { player in
                            PlayerRow(player: player, horizontalMargin: horizontalMargin, updateScore: updateScore, selectedPlayer: $selectedPlayer)
                        }
                    }
                    .padding(.horizontal, horizontalMargin)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .background(Color.white) // Set the background color as needed

                BottomTaskBar()
            }
            .sheet(item: $selectedPlayer) { player in
                PlayerEditView(players: $deck.players, selectedPlayer: $selectedPlayer, removePlayer: removePlayer)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
