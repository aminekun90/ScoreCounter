//
//  PlayerActionsView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//

import SwiftUI

struct DeckActionsView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var deckController = DeckController.shared
    @Binding var isShowingDialog: Bool
    @Binding var presentSideMenu:Bool
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentSideMenu = !presentSideMenu
                }) {
                    Image(systemName: "gamecontroller")
                        .imageScale(.large)
                        .padding()
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                Button(action: {
                    deckController.changeWinningLogic()
                }) {
                    let (winnerImage, winnerText) = deckController.selectedDeck.getWinnerName()
                    if winnerImage {
                        Image( "medal")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 25)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }else{
                        Image( systemName: "equal")
                            .imageScale(.large)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    Text(winnerText)
                }
                
                
                
                Spacer()
                Button(action: {
                    deckController.addPlayer()
                }) {
                    
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .padding()
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                Menu {
                    Button(action: {
                        print("Edit deck clicked")
                    }) {
                        Text("Edit deck")
                        Image(systemName: "folder.fill.badge.gearshape")
                            .imageScale(.large)
                            .padding()
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    Button(action: {
                        deckController.resetAllScores()
                    }) {
                        Text("Reset Scores")
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.large)
                            .padding()
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    
                    Button(role: .destructive) {
                        isShowingDialog = true
                    } label: {
                        Label("Delete All", systemImage: "trash")
                    }.disabled(deckController.selectedDeck.players.isEmpty)
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                        .padding()
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }.confirmationDialog(
                    "Are you sure?",
                    isPresented: $isShowingDialog,
                    titleVisibility: .visible
                ) {
                    Button("Yes", role: .destructive) {
                        deckController.removeAllPlayers()
                        print("Removed all players")
                    }
                    
                    Button("Cancel", role: .cancel) {}
                }
            }
            .background(Color.blue)
            .foregroundColor(.white)
            
            
        }
    }
}

struct DeckActionsView_Previews: PreviewProvider {
    @State static var isShowingDialog = false
    @State static var presentSideMenu = false
    static var previews: some View {
        DeckActionsView(
            isShowingDialog: $isShowingDialog,
            presentSideMenu: $presentSideMenu
        )
    }
}
