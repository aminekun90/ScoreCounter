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
        // Use a DispatchGroup to wait for the asynchronous call to complete
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        dataController.sqliteService.getDecks { decks in
            self.deckList = decks
            
            if let firstDeck = decks.first {
                self.selectedDeck = firstDeck
            } else {
                print("No deck loaded !!")
                let defaultDeck = Deck()
                self.selectedDeck = defaultDeck
                self.deckList.append(defaultDeck)
            }
            
            self.initSelectedDeck()
            
            // Notify that the task is complete
            dispatchGroup.leave()
        }
        
        // Wait for the completion of the asynchronous call
        dispatchGroup.wait()
    }
    public func sortPlayersByScore(){
        selectedDeck.sortPlayersByScore()
        objectWillChange.send()
    }
    public func savePlayersOrder(){
        selectedDeck.syncPlayersOrderToIndex()
        selectedDeck.sortPlayersByOrder()
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
        selectedDeck = Deck()
        self.deckList.append(selectedDeck)
        showNotification(name: "Counter", subtitle: "Just been added", icon: UIImage(systemName:"gamecontroller.fill"))
        syncDeckList()
    }
    
    public func syncDeckList() {
        guard let selectedDeckIndex = deckList.firstIndex(where: { $0.id == selectedDeck.id }) else {
            print("Deck index not found :(")
            return
        }
        savePlayersOrder()
        deckList[selectedDeckIndex] = selectedDeck
        dataController.sqliteService.updateDeck(deck: selectedDeck)
    }
    public func shouldWin(player:Player)->Bool{
        let condition =  selectedDeck.enableWinningAnimation && player.score == selectedDeck.winningScore
        if(condition){
            print("Player win \(player.title)")
        }
        return condition
    }
    public func showWinAnimation(player:Player) -> some View {
            return AnyView(ZStack {
                GifImage("winningAnimation")
            }.zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
            )
    }
    
    public func addPlayer(){
        self.selectedDeck.addPlayer()
        self.syncDeckList()
    }
    
    public func updateScore(_ playerId: UUID, increment: Bool, amount: Int64? = 1){
        self.selectedDeck.updateScore(playerId, increment: increment, amount: amount)
        if(self.selectedDeck.enableScoreAutoSort)
        {
            self.sortPlayersByScore()
        }
        self.syncDeckList()
    }
    
    public func changeWinningLogic() {
        selectedDeck.changeWinningLogic()
        self.syncDeckList()
    }
    
    public func removeAllPlayers() {
        let playerIDsToRemove = self.selectedDeck.players.map { $0.id }
        self.dataController.sqliteService.removePlayers(playerIDs: playerIDsToRemove)
        self.selectedDeck.removeAllPlayers()
        self.syncDeckList()
    }
    
    public func removePlayer(_ player: Player){
        self.selectedDeck.removePlayer(player)
        self.dataController.sqliteService.removePlayers(playerIDs: [player.id])
        self.syncDeckList()
    }
    
    public func removeDeck(deckId:UUID){
        dataController.sqliteService.removeDeck(deckID: deckId)
        if let indexToRemove = deckList.firstIndex(where: { $0.id == deckId }) {
            // Remove the deck at the found index
            deckList.remove(at: indexToRemove)
        }
        selectedDeck = Deck()
        syncDeckList()
        
    }
    
    public func resetAllScores(){
        self.selectedDeck.resetAllScores()
        self.syncDeckList()
    }
}
