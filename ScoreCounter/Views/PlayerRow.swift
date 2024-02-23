//
//  PlayerRow.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//

import SwiftUI
struct PlayerRow: View {
    var player: Player
    var horizontalMargin: CGFloat
    var updateScore: (UUID, Bool, Int?) -> Void
    @Binding var selectedPlayer: Player?

    var body: some View {
        HStack {
            Button(action: {
                selectedPlayer = player
            }) {
                Text(player.title)
                    .font(.title)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .padding(.horizontal, horizontalMargin)
            }

            Spacer()

            Button(action: {
                updateScore(player.id, false, nil)
            }) {
                Image(systemName: "minus")
                    .imageScale(.large)
                    .padding(10) // Add padding to the button
            }
            .contentShape(Rectangle()) // Make the button tappable outside the image
            .contextMenu {
                menuItems(incrementAction: false)
            }

            Text("\(player.score)")
                .font(.title)

            Button(action: {
                updateScore(player.id, true, nil)
            }) {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .padding(10) // Add padding to the button
            }
            .contentShape(Rectangle()) // Make the button tappable outside the image
            .contextMenu {
                menuItems(incrementAction: true)
            }
        }
        .padding(.horizontal, 15)
        .background(player.color)
        .foregroundColor(.white)
        .cornerRadius(10)
    }

    private func menuItems(incrementAction: Bool) -> some View {
        let increments: [Int] = [5, 10, 15, 30]

        return VStack {
            ForEach(increments, id: \.self) { increment in
                Button(action: {
                    updateScore(player.id, incrementAction, increment)
                }) {
                    Text("\(increment)")
                }
            }
        }
    }
}
