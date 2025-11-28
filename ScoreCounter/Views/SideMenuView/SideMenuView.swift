//
//  SideMenuView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 25/02/2024.
//

import Foundation
import SwiftUI

struct SideMenuView: View {
    @ObservedObject var deckController = DeckController.shared
    @Binding var selectedSideMenuTab: UUID
    @Binding var presentSideMenu: Bool
    @State var presentEditDeck: Bool = false
    
    var body: some View {
        HStack {
            
            ZStack{
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    AppTitleView()
                        .frame(height: 140)
                        .padding(.bottom, 30).padding(.top,60)
                    
                    ForEach(deckController.deckList) { deck in
                        DeckRowView(
                            isSelected: selectedSideMenuTab == deck.id, // Pass your isSelected value here
                            title: deck.name,
                            action: {
                                // Handle tap action
                                print("Item tapped: \(deck.name)")
                                selectedSideMenuTab = deck.id
                                deckController.selectDeck(with: deck.id)
                                presentEditDeck.toggle()
                            },
                            removeAction: {
                                // Handle remove action
                                deckController.removeDeck(deckId: deck.id)
                            }
                        )
                    }
                    Spacer()
                }
                .padding(.top, 60)
                .frame(width: 270)
                .background(.white)
            }
            Spacer()
        }.sheet(isPresented: $presentEditDeck) { // Present edit deck sheet
            EditDeckView(isPresented: $presentEditDeck, deck: $deckController.selectedDeck)
        }
    }
    
    func AppTitleView() -> some View {
        VStack(alignment: .center, spacing: 0) { // Adjusted alignment and added spacing
            HStack {
                Spacer()
                Text("Score Counter")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 5) // Adjusted bottom padding
            
            Button(action: {
                deckController.addNewDeck()
            }) {
                Image(systemName: "folder.fill.badge.plus")
                    .imageScale(.large)
                    .padding(7)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .background(SettingsController.shared.backgroundColor)
                    .foregroundColor(SettingsController.shared.textColor)
            }
            .cornerRadius(10)
            
            Spacer() // Added spacer at the bottom
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    @State static var presentSideMenu = true
    @State static var selectedSideMenuTab = DeckController.shared.selectedDeck.id
    static var previews: some View {
        SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView( selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)))
    }
}
