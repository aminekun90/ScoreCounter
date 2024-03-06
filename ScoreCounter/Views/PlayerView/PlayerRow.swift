//
//  PlayerRow.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//

import SwiftUI
extension Color {
    var isBright: Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Adjust the threshold as needed
        let brightness = (red * 299 + green * 587 + blue * 114) / 1000
        return brightness > 0.7
    }
}
class IncrementState: ObservableObject {
    @Published var incrementAction: Bool = false
}
struct PlayerRow: View {
    @ObservedObject var deckController = DeckController.shared
    var player: Player
    var horizontalMargin: CGFloat
    @Binding var selectedPlayer: Player?
    var totalPlayers: Int
    @State private var incrementPresented = false
    @StateObject private var incrementState = IncrementState()
    @State private var incrementBy:String = ""
    var body: some View {
        HStack {
            Image(player.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(.purple.opacity(0.5), lineWidth: 10)
                )
                .cornerRadius(50)
                .padding(.trailing, 10) // Add padding on the trailing side
            deckController.showWinAnimation(score: player.score)
            Button(action: {
                selectedPlayer = player
            }) {
                VStack(alignment: .leading) { // Adjusted alignment
                    Text(player.title)
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: heightForPlayerRow())
                        .cornerRadius(10)
                        .padding(.horizontal, horizontalMargin)
                        
                }
            }
            
            Spacer()
            
            Button(action: {
                deckController.updateScore(player.id, increment: false, amount: nil)
            }) {
                Image(systemName: "minus")
                    .imageScale(.large)
                    .padding(10)
            }
            .contentShape(Rectangle())
            .simultaneousGesture(
                LongPressGesture()
                    .onEnded { _ in
                        vibratePhone()
                        incrementState.incrementAction = false
                        incrementPresented.toggle()
                    }
            )
            
            Text("\(player.score)")
                .font(.title)
            
            Button(action: {
                deckController.updateScore(player.id, increment: true, amount: nil)
            }) {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .padding(10)
            }
            .contentShape(Rectangle())
            .simultaneousGesture(
                LongPressGesture()
                    .onEnded { _ in
                        vibratePhone()
                        incrementState.incrementAction = true
                        incrementPresented.toggle()
                    }
            )
        }.background(player.color)
            .foregroundColor(player.color.isBright ? .black : .white)
            .frame(height: heightForPlayerRow())
            .sheet(isPresented: $incrementPresented) {
                VStack{
                    Text(player.title)
                        .font(.title)
                        .frame(maxWidth: .infinity, maxHeight: heightForPlayerRow())
                        .cornerRadius(10).background(player.color)
                        .foregroundColor(player.color.isBright ? .black : .white)
                    
                    HStack(spacing: 10) {
                      
                        ForEach(SettingsController.shared.appSettings.increments.values, id: \.self) { amount in
                            Button(action: {
                                deckController.updateScore(player.id, increment: incrementState.incrementAction, amount: amount)
                                incrementPresented.toggle()
                            }) {
                                Text("\(incrementState.incrementAction ? "+" : "-") \(amount)")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.accentColor) // Adjust the background color as needed
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    Text("You can edit these values in settings ").font(.system(size: 10))
                    
                    HStack {
                        Button(action: {
                            incrementState.incrementAction = false
                        }) {
                            Image(systemName: "minus")
                                .imageScale(.large)
                                .frame(width: 40, height: 40) // Set a fixed size for the button
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            incrementState.incrementAction = true
                        }) {
                            Image(systemName: "plus")
                                .imageScale(.large)
                                .frame(width: 40, height: 40) // Set the same fixed size for the button
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Spacer()
                        
                        TextField("Increment Value", text: $incrementBy)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        Button(action:{
                            deckController.updateScore(player.id, increment: incrementState.incrementAction, amount: Int64(incrementBy))
                            incrementPresented.toggle()
                        }){
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                                .frame(width: 40, height: 40)
                                .cornerRadius(10)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal,10)
                    .presentationDetents([.fraction(0.7)])
                }.frame(maxHeight: .infinity, alignment: .top)
            }
    }
    
    
    private func heightForPlayerRow() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return totalPlayers > 3 ? 70 : screenHeight / 3
    }
    
    
}
