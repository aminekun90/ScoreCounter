//
//  landingPageView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//

import SwiftUI

struct LandingPageView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var deckController = DeckController.shared
    var body: some View {
        VStack {
            Spacer()
            
            Image("calcicon")
                .resizable()
                .aspectRatio(contentMode: .fill) // Set aspectRatio to .fill
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Text("Click on the \"+\" at the top right to add a new player ")
                .foregroundColor( colorScheme == .dark ? .white : .black)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Add new Player",action:{
                deckController.addPlayer()
            })
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

