//
//  DeckController.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 25/02/2024.
//

import Foundation
import SpriteKit
import SwiftUI


class DeckController: ObservableObject {
    @Published var deckList: [Deck] = []
    @Published var selectedDeck: Deck!
    private var dataController: DataController
    
    static var shared = DeckController(dataController: DataController.shared)
    
    init(dataController: DataController) {
        self.dataController = dataController
        dataController.sqliteService.getDecks { decks in
            self.deckList = decks
            self.selectedDeck = self.deckList.first ?? Deck() // Initialize selectedDeck
            self.initSelectedDeck()
        }
    }
    
    private func initSelectedDeck() {
        if let firstDeck = deckList.first {
            selectedDeck = firstDeck
        }
    }
    
    public func setSelectedDeck(deck: Deck){
        self.selectedDeck = deck
    }
    
    public func selectDeck(with deckId: UUID) {
        if let newSelectedDeck = deckList.first(where: { $0.id == deckId }) {
            selectedDeck = newSelectedDeck
        }
    }
    public func addNewDeck(){
        self.deckList.append(Deck())
        showNotification(name: "Counter", subtitle: "Just been added", icon: UIImage(systemName:"gamecontroller.fill"))
        syncDeckList()
    }
    public func syncDeckList() {
        guard let selectedDeckIndex = deckList.firstIndex(where: { $0.id == selectedDeck.id }) else {
            return
        }
        
        deckList[selectedDeckIndex] = selectedDeck
        dataController.sqliteService.updateDeck(deck: selectedDeck)
    }
  

   
    // ---------------------------selected-deck-helpers--------------------------------//
    public func showWinAnimation(score: Int64) -> some View {
        
        if score >= selectedDeck.winningScore {
            return AnyView(HStack {
                Image(systemName: "crown")
                Image(systemName: "fireworks")
            }
            .foregroundColor(.yellow))
        }
        return AnyView(EmptyView())
    }
    public func addPlayer(){
        self.selectedDeck.addPlayer()
        self.syncDeckList()
    }
    public func updateScore(_ playerId: UUID, increment: Bool, amount: Int64? = 1){
        self.selectedDeck.updateScore(playerId, increment: increment, amount: amount)
        self.syncDeckList()
    }
    public func changeWinningLogic() {
        selectedDeck.changeWinningLogic()
        self.syncDeckList()
    }
    
    public func removeAllPlayers(){
        self.selectedDeck.removeAllPlayers()
        self.syncDeckList()
    }
    public func removePlayer(_ player: Player?){
        self.selectedDeck.removePlayer(player)
        self.syncDeckList()
    }
    public func resetAllScores(){
        self.selectedDeck.resetAllScores()
        self.syncDeckList()
    }
}
