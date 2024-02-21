//
//  PlayerEditView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//
import SwiftUI

struct PlayerEditView: View {
    @Binding var players: [Player]
    @Binding var selectedPlayer: Player?
    @State private var editedTitle: String = ""
    @State private var editedScore: String = ""
    @State private var editedColor: Color = .blue
    var colors: [Color] = [.red, .green, .blue, .orange, .purple, .yellow, .pink, .teal]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Player Details")) {
                    TextField("Title", text: $editedTitle)
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
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(editedTitle.isEmpty || Int(editedScore) == nil)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .multilineTextAlignment(.center)
                }
            }
            .navigationTitle("Edit Player")
        }
        .onAppear {
            guard let playerIndex = players.firstIndex(of: selectedPlayer!) else {
                return
            }
            editedTitle = players[playerIndex].title
            editedScore = "\(players[playerIndex].score)"
            editedColor = players[playerIndex].color
        }
    }
    
    func saveChanges() {
        guard let playerIndex = players.firstIndex(of: selectedPlayer!) else {
            return
        }
        guard let newScore = Int(editedScore) else {
            return
        }
        
        players[playerIndex].title = editedTitle
        players[playerIndex].score = newScore
        players[playerIndex].color = editedColor
        selectedPlayer = nil
    }
}					
