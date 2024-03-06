//
//  PlayerEditView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//
import SwiftUI

struct PlayerEditView: View {
    @ObservedObject var deckController = DeckController.shared
    @Binding var selectedPlayer: Player?
    @State private var editedTitle: String = ""
    @State private var editedScore: String = ""
    @State private var editedColor: Color = Color.blue
    
    @State private var isShowingDeleteConfirmation = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Player Details")) {
                    HStack {
                        TextField("Title", text: $editedTitle)
                    }
                    
                    TextField("Score", text: $editedScore)
                        .keyboardType(.numberPad)
                    
                    ColorPicker("Pick color", selection: $editedColor)
                }
                
                Section {
                    Button(action: {
                        saveChanges()
                    }) {
                        Text("Save")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                            .multilineTextAlignment(.center)
                    }
                    .disabled(editedTitle.isEmpty || Int(editedScore) == nil)
                }
            }
            .navigationTitle("Edit Player")
            .navigationBarItems(
                leading: Button("Cancel") {
                    selectedPlayer = nil
                },
                trailing:
                    // Trash icon for delete action
                Button(action: {
                    isShowingDeleteConfirmation = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                    .alert(isPresented: $isShowingDeleteConfirmation) {
                        Alert(
                            title: Text("Delete Player"),
                            message: Text("Are you sure you want to delete this player?"),
                            primaryButton: .default(Text("Cancel")),
                            secondaryButton: .destructive(Text("Delete")) {
                                deckController.removePlayer(selectedPlayer)
                                selectedPlayer = nil
                            }
                        )
                    }
            )
        }
        .onAppear {
            guard let playerIndex =  deckController.selectedDeck.players.firstIndex(of: selectedPlayer!) else {
                return
            }
            editedTitle = deckController.selectedDeck.players[playerIndex].title
            editedScore = "\( deckController.selectedDeck.players[playerIndex].score)"
            editedColor = deckController.selectedDeck.players[playerIndex].color
        }
    }
    
    func saveChanges() {
        guard let playerIndex =  deckController.selectedDeck.players.firstIndex(of: selectedPlayer!) else {
            return
        }
        guard let newScore = Int64(editedScore) else {
            return
        }
        
        deckController.selectedDeck.players[playerIndex].title = editedTitle
        deckController.selectedDeck.players[playerIndex].score = newScore
        deckController.selectedDeck.players[playerIndex].color = editedColor
        deckController.syncDeckList()
        selectedPlayer = nil
    }
}

