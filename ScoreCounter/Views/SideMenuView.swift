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
    
    var body: some View {
            HStack {
                
                ZStack{
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        AppTitleView()
                            .frame(height: 140)
                            .padding(.bottom, 30).padding(.top,60)
                        
                        ForEach(deckController.deckList) { deck in
                            RowView(isSelected: selectedSideMenuTab == deck.id, title: deck.name) {
                                selectedSideMenuTab = deck.id
                                presentSideMenu.toggle()
                                deckController.selectDeck(with: deck.id)
                                
                            }
                        }
                        Spacer()
                    }
                    .padding(.top, 60)
                    .frame(width: 270)
                    .background(.white)
                }
                Spacer()
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
                        .background(SettingsController.shared.getAppearenceColor(shouldBe: .black))
                        .foregroundColor(SettingsController.shared.getAppearenceColor(shouldBe: .white))
                }
                .cornerRadius(10)
                
                Spacer() // Added spacer at the bottom
            }
        }
    
    func RowView(isSelected: Bool, title: String, hideDivider: Bool = false, action: @escaping (()->())) -> some View{
        Button{
            action()
        } label: {
            VStack(alignment: .leading){
                HStack(spacing: 20){
                    Rectangle()
                        .fill(isSelected ? .purple : .white)
                        .frame(width: 5)
                    Text(title)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(isSelected ? .black : .gray)
                    Spacer()
                }
            }
        }
        .frame(height: 50)
        .background(
            LinearGradient(colors: [isSelected ? Color.purple.opacity(0.5) : Color.white.opacity(0), .white], startPoint: .leading, endPoint: .trailing)
        )
    }
}

struct SideMenuView_Previews: PreviewProvider {
    @State static var presentSideMenu = true
    @State static var selectedSideMenuTab = DeckController.shared.selectedDeck.id
    
    static var previews: some View {
        SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView( selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)))
    }
}
