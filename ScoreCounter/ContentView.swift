//
//  ContentView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//

import SwiftUI

struct ContentView: View {
    @State public var players: [Player] = []
    @State private var selectedPlayer: Player? = nil
    let horizontalMargin: CGFloat = 10
    @State private var isShowingDialog = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) {
                    PlayerActionsView(players: $players, isShowingDialog: $isShowingDialog, addPlayer: addPlayer,removeAllPlayers:removeAllPlayers)
                    if(players.count==0)
                    {
                        LandingPageView(addPlayer: addPlayer)
                    }
                    ForEach(players) { player in
                        PlayerRow(player: player, horizontalMargin: horizontalMargin, updateScore: updateScore, selectedPlayer: $selectedPlayer)
                    }
                }
                .padding(.horizontal, horizontalMargin)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .background()
            .sheet(item: $selectedPlayer) { player in
                PlayerEditView(players: $players, selectedPlayer: $selectedPlayer,removePlayer: removePlayer)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
