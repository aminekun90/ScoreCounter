//
//  PlayerEditView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//
import SwiftUI

struct PlayerEditView: View {
    @Binding var deck:Deck
    @Binding var selectedPlayer: Player?
    @State private var editedTitle: String = ""
    @State private var editedScore: String = ""
    @State private var editedColor: Color = .blue
    var colors: [Color] = [.red, .green, .blue, .orange, .purple, .yellow, .pink, .teal, .indigo, .brown]
    var removePlayer: (inout Deck, Player?) -> Void
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

                           Picker("Color", selection: $editedColor) {
                               ForEach(colors, id: \.self) { color in
                                   Text(color.description.capitalized)
                                       .foregroundColor(color)
                               }
                           }
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
                                                removePlayer(&deck,selectedPlayer)
                                                selectedPlayer = nil
                                            }
                                        )
                                    }
                              )
                          }
        .onAppear {
            guard let playerIndex =  deck.players.firstIndex(of: selectedPlayer!) else {
                return
            }
            editedTitle = deck.players[playerIndex].title
            editedScore = "\( deck.players[playerIndex].score)"
            editedColor =  deck.players[playerIndex].color
        }
    }

    func saveChanges() {
        guard let playerIndex =  deck.players.firstIndex(of: selectedPlayer!) else {
            return
        }
        guard let newScore = Int(editedScore) else {
            return
        }

        deck.players[playerIndex].title = editedTitle
        deck.players[playerIndex].score = newScore
        deck.players[playerIndex].color = editedColor
        selectedPlayer = nil
    }
}
