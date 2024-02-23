//
//  landingPageView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//

import SwiftUI

struct LandingPageView: View {
    @Environment(\.colorScheme) var colorScheme
    var addPlayer: () -> Void
    var body: some View {
        VStack {
            Spacer() // Push the content to the top
            
            // Your logo image
            Image("calcicon") // Replace with the actual name of your image asset
                .resizable()
                .aspectRatio(contentMode: .fill) // Set aspectRatio to .fill
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Text("Click on the \"+\" at the top right to add a new player ")
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Add new Player",action:addPlayer)
            Spacer() // Push the content to the bottom
            
            // Any other content you want to include
        }
        .edgesIgnoringSafeArea(.all) // Ignore safe area to cover the entire screen
    }
}

