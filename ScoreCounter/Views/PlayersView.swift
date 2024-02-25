//
//  PlayersView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 23/02/2024.
//

import Foundation
import SwiftUI

struct PlayersView: View {
    @State public var deck = Deck()
    @State private var isShowingDialog = false
    @State private var selectedPlayer: Player? = nil
    let horizontalMargin: CGFloat = 10

    var body: some View {
        ScrollView {
                    LazyVStack(spacing: 0) { // Set spacing to 0
                        if deck.players.isEmpty {
                            LandingPageView(deck: $deck, addPlayer: addPlayer)
                        }
                        
                        ForEach(deck.players) { player in
                            PlayerRow(deck: $deck, player: player, horizontalMargin: horizontalMargin, updateScore: updateScore, selectedPlayer: $selectedPlayer,totalPlayers: $deck.players.count)
                        }
                    }
                }.padding(.top, 60).padding(.bottom,60)
        .overlay(
            PlayerActionsView(deck: $deck, isShowingDialog: $isShowingDialog, addPlayer: addPlayer, removeAllPlayers: removeAllPlayers, changeWinningLogic: changeWinningLogic)
                .frame(maxWidth: .infinity, alignment: .top)
        )
        .sheet(item: $selectedPlayer) { player in
            PlayerEditView(deck: $deck, selectedPlayer: $selectedPlayer, removePlayer: removePlayer)
        }
    }
}

