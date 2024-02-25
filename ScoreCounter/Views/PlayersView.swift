//
//  PlayersView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 23/02/2024.
//

import Foundation
import SwiftUI

struct PlayersView:View {
    @State public var deck = Deck()
    @State private var isShowingDialog = false
    @State private var selectedPlayer: Player? = nil
    let horizontalMargin: CGFloat = 10
   
    var body: some View{
        ScrollView {
            VStack() {
                PlayerActionsView(deck: $deck, isShowingDialog: $isShowingDialog, addPlayer: addPlayer, removeAllPlayers: removeAllPlayers,changeWinningLogic:changeWinningLogic)
                if deck.players.isEmpty {
                    LandingPageView(deck: $deck,addPlayer: addPlayer)
                }
                ForEach(deck.players) { player in
                    PlayerRow(deck:$deck,player: player, horizontalMargin: horizontalMargin, updateScore: updateScore, selectedPlayer: $selectedPlayer)
                }
            }
            
        }
        
        
        .sheet(item: $selectedPlayer) { player in
            PlayerEditView(deck:$deck, selectedPlayer: $selectedPlayer, removePlayer: removePlayer)
                   }
    }
}
