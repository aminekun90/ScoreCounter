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
    @Binding var draggedPlayer: Player?
    var totalPlayers: Int

    @State private var incrementPresented = false
    @State private var isPresentedWin = false
    @StateObject private var incrementState = IncrementState()
    @State private var incrementBy: String = ""

    var body: some View {
        HStack(spacing: 10) {
            // DRAG HANDLE
            HStack(){
                Image(player.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .overlay(RoundedRectangle(cornerRadius: 50)
                                .stroke(.purple.opacity(0.5), lineWidth: 10))
                    .cornerRadius(50)
                    

                deckController.showWinIcon(player: player)

                Button(action: { selectedPlayer = player }) {
                    VStack(alignment: .leading) {
                        Text(player.title)
                            .font(.custom("Oswald-Regular", size: 20))
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: heightForPlayerRow())
                            .cornerRadius(10)
                            .padding(.horizontal, horizontalMargin)
                    }
                }

                Spacer()
            } .onDrag {
                self.draggedPlayer = player
                print("drag ...")
                return NSItemProvider(object: player.id.uuidString as NSString)
            }
            HStack(){
                incrementButton(isIncrement: false)
                Text("\(player.score)")
                    .font(.custom("Oswald-Bold", size: 20))
                incrementButton(isIncrement: true)
            }
            
        }
        .background(player.color)
        .foregroundColor(player.color.isBright ? .black : .white)
        .frame(height: heightForPlayerRow())
        .sheet(isPresented: $incrementPresented) { incrementSheet() }
        .popover(isPresented: $isPresentedWin) { winPopover() }
       
    }

    // MARK: - Increment Button
    @ViewBuilder
    private func incrementButton(isIncrement: Bool) -> some View {
        let tapGesture = TapGesture().onEnded {
            let amount = Int64(incrementBy.trimmingCharacters(in: .whitespacesAndNewlines))
                         ?? deckController.selectedDeck.increment
            deckController.updateScore(player.id, increment: isIncrement, amount: amount)
            isPresentedWin = deckController.shouldWin(player: player)
        }

        let longPressGesture = LongPressGesture(minimumDuration: 0.35)
            .onEnded { _ in
                vibratePhone()
                incrementState.incrementAction = isIncrement
                incrementPresented = true
            }

        ZStack {
            Image(systemName: isIncrement ? "plus" : "minus")
                .imageScale(.large)
                .padding(10)
                .frame(width: 40, height: 40)
        }
        .contentShape(Rectangle())
        .highPriorityGesture(tapGesture)
        .simultaneousGesture(longPressGesture)
    }

    // MARK: - Increment Sheet
    @ViewBuilder
        private func incrementSheet() -> some View {
            VStack {
                // Player title
                Text(player.title)
                    .font(.custom("Oswald-Regular", size: 20))
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .background(player.color)
                    .foregroundColor(player.color.isBright ? .black : .white)
                    .cornerRadius(10,corners:[.topLeft,.topRight])
                    

                // Preset increments
                HStack(spacing: 10) {
                    ForEach(SettingsController.shared.appSettings.increments.values, id: \.self) { amount in
                        Button(action: {
                            deckController.updateScore(player.id, increment: incrementState.incrementAction, amount: amount)
                            incrementPresented = false
                        }) {
                            Text("\(incrementState.incrementAction ? "+" : "-") \(amount)")
                                .lineLimit(2)
                                .truncationMode(.tail)
                                .padding()
                                .font(.custom("Oswald-Bold", size: 20))
                                .frame(maxWidth: .infinity)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(15)

                Text("You can edit these values in settings")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)  // Force full width
                    .multilineTextAlignment(.center)

                // Custom increment input row
                HStack(spacing: 15) {
                    Button(action: { incrementState.incrementAction = false }) {
                        Image(systemName: "minus")
                            .imageScale(.large)
                            .frame(width: 40, height: 40)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: { incrementState.incrementAction = true }) {
                        Image(systemName: "plus")
                            .imageScale(.large)
                            .frame(width: 40, height: 40)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    TextField("Increment Value", text: $incrementBy)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .frame(maxWidth: .infinity)

                    Button(action: {
                        let amount = Int64(incrementBy.trimmingCharacters(in: .whitespacesAndNewlines))
                                     ?? deckController.selectedDeck.increment
                        deckController.updateScore(player.id, increment: incrementState.incrementAction, amount: amount)
                        isPresentedWin = deckController.shouldWin(player: player)
                        incrementPresented = false
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .imageScale(.large)
                            .frame(width: 40, height: 40)
                    }
                }
                .frame(maxWidth: .infinity) // <-- make the HStack stretch
                .padding(.horizontal, 10)
            }
            .presentationDetents([.fraction(0.7)])
            .frame(maxHeight: .infinity, alignment: .top)
        }
    // MARK: - Win Popover
    @ViewBuilder
    private func winPopover() -> some View {
        HStack {
            Text("\(player.title) wins ")
            Image(systemName: "crown.fill").foregroundColor(.yellow)
        }
        .font(.custom("Oswald-Regular", size: 20))
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(player.color)
        .foregroundColor(player.color.isBright ? .black : .white)
        .cornerRadius(10)

        deckController.showWinAnimation(player: player)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    isPresentedWin = false
                }
            }
    }

    private func heightForPlayerRow() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return totalPlayers > 3 ? 70 : screenHeight / 3
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {
    let radius: CGFloat
    let corners: UIRectCorner
    

    init(radius: CGFloat = .infinity, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
