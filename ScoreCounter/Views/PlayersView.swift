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
    @State private var draggedPlayer: Player?
    @State private var dropOccurred = false
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
                        PlayerRow(player: player, horizontalMargin: horizontalMargin, selectedPlayer: $selectedPlayer, totalPlayers: deckController.selectedDeck?.players.count ?? 0).onDrag {
                            self.draggedPlayer = player
                            return NSItemProvider()
                        }
                        .onDrop(of: ["player"], delegate: DropViewDelegate(destinationItem: player, draggedPlayer: $draggedPlayer, players: $deckController.selectedDeck.players,dropOccurred: $dropOccurred))
                    }
                }
            }
            .onChange(of:dropOccurred) {
                DeckController.shared.syncDeckList()
                dropOccurred = false
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

class DropViewDelegate: DropDelegate {
    let destinationItem: Player
    @Binding var draggedPlayer: Player?
    @Binding var players: [Player]
    @Binding var dropOccurred: Bool
    init(destinationItem:Player,draggedPlayer: Binding<Player?>, players: Binding<[Player]>,dropOccurred: Binding<Bool>) {
        _draggedPlayer = draggedPlayer
        _players = players
        self.destinationItem = destinationItem
        _dropOccurred = dropOccurred
    }
    
    func dropEntered(info: DropInfo) {
        // Swap Items
        vibratePhone()
        if let draggedPlayer = draggedPlayer {
            let fromIndex = players.firstIndex(of: draggedPlayer)
            if let fromIndex {
                let toIndex = players.firstIndex(of: destinationItem)
                
                if let toIndex, fromIndex != toIndex {
                    withAnimation {
                        self.players.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex)
                    }
                }
            }
        }
    }
    
    func dropExited(info: DropInfo) {
        DeckController.shared.syncDeckList()
    }
    
    func performDrop(info: DropInfo) -> Bool {
        // Handle the drop action here
        guard let fromIndex = players.firstIndex(of: draggedPlayer!),
              let toIndex = droppedIndex(for: info) else {
            return false
        }
        
        withAnimation {
            self.players.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex)
        }
        
        // Reset any highlighting or cleanup
        self.draggedPlayer = nil
        dropOccurred = true
        return true
    }
    
    private func droppedIndex(for info: DropInfo) -> Int? {
        return nil
    }
}



