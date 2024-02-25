//
//  PlayersView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 23/02/2024.
//

import Foundation
import SwiftUI

struct PlayersView: View {
    @ObservedObject var deckController = DeckController.shared
    @State private var isShowingDialog = false
    @State private var selectedPlayer: Player? = nil
    @State var selectedSideMenuTab = DeckController.shared.selectedDeck.id
    @State var presentSideMenu = false
    let horizontalMargin: CGFloat = 10

    var body: some View {
        ZStack {
            // ScrollView content
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    if deckController.selectedDeck?.players.isEmpty ?? true {
                        LandingPageView()
                    }else{
                        HStack {
                            Spacer()
                            Image(systemName: "crown.fill").foregroundColor(.yellow)
                            Text("Reach \(deckController.selectedDeck.winningScore) points to win")
                            Spacer()
                        }
                        .padding(.bottom, 10)
                        .padding(.top, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        
                    }

                    ForEach(deckController.selectedDeck?.players ?? []) { player in
                        PlayerRow(player: player, horizontalMargin: horizontalMargin, selectedPlayer: $selectedPlayer, totalPlayers: deckController.selectedDeck?.players.count ?? 0)
                    }
                }
            }
            .padding(.top, 59)
            .padding(.bottom, 60)
           
            SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)))
            
        }.overlay(VStack {
            DeckActionsView(isShowingDialog: $isShowingDialog, presentSideMenu: $presentSideMenu)
                .frame(maxWidth: .infinity, alignment: .top)
                .background(SettingsController.shared.getAppearenceColor(shouldBe: .black)) // Set your preferred background color
                .foregroundColor(.white) // Set your preferred text color
            Spacer()
        }
        .ignoresSafeArea(.all, edges: .bottom))
        .sheet(item: $selectedPlayer) { player in
            PlayerEditView(selectedPlayer: $selectedPlayer)
        }
    }
}
