//
//  PlayersView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 23/02/2024.
//

import SwiftUI

class SharedData: ObservableObject {
    @Published var round: Int64 = 1
}

struct PlayersView: View {
    @ObservedObject var deckController = DeckController.shared
    @State private var isShowingDialog = false
    @State private var selectedPlayer: Player? = nil
    @State var selectedSideMenuTab = DeckController.shared.selectedDeck.id
    @State var presentSideMenu = false
    @State private var draggedPlayer: Player?
    @State private var dropOccurred = false
    @State private var isEditingWinningScore = false
    @StateObject private var sharedData: SharedData = SharedData()
    let horizontalMargin: CGFloat = 10

    var body: some View {
        ZStack {
            VStack {
                if deckController.selectedDeck?.players.isEmpty ?? true {
                    LandingPageView()
                } else {
                    headerView()
                    roundView()
                    playerListView()
                }
            }

            SideMenu(isShowing: $presentSideMenu,
                     content: AnyView(SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)))
        }
        .overlay(VStack {
            DeckActionBarView(isShowingDialog: $isShowingDialog, presentSideMenu: $presentSideMenu)
                .frame(maxHeight: .infinity, alignment: .top)
        }.ignoresSafeArea(.all, edges: .bottom))
        .sheet(item: $selectedPlayer) { player in
            PlayerEditView(selectedPlayer: $selectedPlayer)
        }
        .environmentObject(sharedData)
    }

    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            Button(action: { isEditingWinningScore.toggle() }) {
                Spacer()
                Image(systemName: "crown.fill").foregroundColor(.yellow)
                Text("Reach \(deckController.selectedDeck.winningScore) points to win")
                Spacer()
            }
            .sheet(isPresented: $isEditingWinningScore) {
                EditWinningScoreView(
                    isPresented: $isEditingWinningScore,
                    winningScore: $deckController.selectedDeck.winningScore
                )
            }
            .padding(.bottom, 5)
            .padding(.top, 60)
            .background(SettingsController.shared.backgroundColor)
            .foregroundColor(SettingsController.shared.textColor)
        }
        .frame(maxHeight: 80, alignment: .top)
    }

    @ViewBuilder
    private func roundView() -> some View {
        HStack {
            Text("Round")
            Button(action: {
                if deckController.selectedDeck.round > 1 {
                    deckController.selectedDeck.round -= 1
                    sharedData.round = deckController.selectedDeck.round
                }
            }) {
                Image(systemName: "minus.circle")
                    .imageScale(.large)
                    .padding(10)
                    .frame(width: 40, height: 40)
            }
            .contentShape(Rectangle())

            Text("\(sharedData.round)")

            Button(action: {
                deckController.selectedDeck.round += 1
                sharedData.round = deckController.selectedDeck.round
            }) {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
                    .padding(10)
                    .frame(width: 40, height: 40)
            }
            .contentShape(Rectangle())
        }
        .frame(maxHeight: 40, alignment: .top)
    }

    @ViewBuilder
    private func playerListView() -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(deckController.selectedDeck?.players ?? []) { player in
                    PlayerRow(
                        player: player,
                        horizontalMargin: horizontalMargin,
                        selectedPlayer: $selectedPlayer,
                        draggedPlayer: $draggedPlayer,
                        totalPlayers: deckController.selectedDeck?.players.count ?? 0
                    )
                    .onDrop(of: ["public.text"], delegate: DropViewDelegate(
                        destinationItem: player,
                        draggedPlayer: $draggedPlayer,
                        players: $deckController.selectedDeck.players,
                        dropOccurred: $dropOccurred
                    ))
                }
            }
        }
        .padding(.bottom, 60)
        .frame(maxHeight: .infinity, alignment: .top)
        .onChange(of: dropOccurred) {
            DeckController.shared.syncDeckList()
            dropOccurred = false
        }
    }
}

// MARK: - Drop Delegate
class DropViewDelegate: DropDelegate {
    let destinationItem: Player
    @Binding var draggedPlayer: Player?
    @Binding var players: [Player]
    @Binding var dropOccurred: Bool

    init(destinationItem: Player,
         draggedPlayer: Binding<Player?>,
         players: Binding<[Player]>,
         dropOccurred: Binding<Bool>) {
        _draggedPlayer = draggedPlayer
        _players = players
        self.destinationItem = destinationItem
        _dropOccurred = dropOccurred
    }

    func dropEntered(info: DropInfo) {
        guard let draggedPlayer = draggedPlayer,
              let fromIndex = players.firstIndex(of: draggedPlayer),
              let toIndex = players.firstIndex(of: destinationItem),
              fromIndex != toIndex else { return }

        withAnimation {
            players.move(fromOffsets: IndexSet(integer: fromIndex),
                         toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
    }

    func performDrop(info: DropInfo) -> Bool {
        draggedPlayer = nil
        dropOccurred = true
        return true
    }
}

struct PlayersView_Previews: PreviewProvider {
    static var previews: some View {
        PlayersView()
    }
}
