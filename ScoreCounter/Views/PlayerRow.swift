//
//  PlayerRow.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//

import SwiftUI

struct PlayerRow: View {
    @ObservedObject var deckController = DeckController.shared
    var player: Player
    var horizontalMargin: CGFloat
    @Binding var selectedPlayer: Player?
    var totalPlayers: Int

    var body: some View {
        HStack {
            Button(action: {
                selectedPlayer = player
            }) {
                Text(player.title)
                    .font(.title)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: heightForPlayerRow())
                    .cornerRadius(10)
                    .padding(.horizontal, horizontalMargin)
            }

            Button(action: {
                deckController.updateScore(player.id, increment:false, amount:nil)
            }) {
                Image(systemName: "minus")
                    .imageScale(.large)
                    .padding(10)
            }
            .contentShape(Rectangle())
            .contextMenu {
                menuItems(incrementAction: false)
            }

            Text("\(player.score)")
                .font(.title)

            Button(action: {
                deckController.updateScore( player.id, increment:true, amount:nil)
            }) {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .padding(10)
            }
            .contentShape(Rectangle())
            .contextMenu {
                menuItems(incrementAction: true)
            }
        }
        .background(player.color)
        .foregroundColor(.white)
        .frame(height: heightForPlayerRow())
    }

    private func heightForPlayerRow() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return totalPlayers > 3 ? 70 : screenHeight / 3
    }

    private func menuItems(incrementAction: Bool) -> some View {
        let increments: [Int] = [5, 10, 15, 30]

        return VStack {
            ForEach(increments, id: \.self) { amount in
                Button(action: {
                    deckController.updateScore( player.id, increment:incrementAction, amount:amount)
                }) {
                    Text("\(amount)")
                }
            }
        }
    }
}
