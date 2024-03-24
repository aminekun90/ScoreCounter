import SwiftUI

struct DeckActionsView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var deckController = DeckController.shared
    @Binding var isShowingDialog: Bool
    @Binding var presentSideMenu: Bool
    @State private var presentEditDeck = false // Added state for presenting edit deck view
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    presentSideMenu.toggle()
                    vibratePhone()
                }) {
                    Image(systemName: "gamecontroller")
                        .imageScale(.large)
                        .padding()
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                Button(action: {
                    deckController.changeWinningLogic()
                    vibratePhone()
                }) {
                    let (winnerImage, winnerText) = deckController.selectedDeck.getWinnerName()
                    if winnerImage {
                        Image("medal")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 25)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    } else {
                        Image(systemName: "equal")
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
                        print("Sort deck clicked")
                        deckController.sortPlayersByScore()
                    }) {
                        Label("Sorting by score", systemImage: "list.bullet.clipboard")
                    }
                    Button(action: {
                        presentEditDeck.toggle() // Toggle edit deck sheet
                    }) {
                        Label("Edit deck", systemImage: "folder.fill.badge.gearshape")
                    }
                    Button(action: {
                        deckController.resetAllScores()
                    }) {
                        Label("Reset Scores", systemImage: "arrow.clockwise")
                    }
                    Button(action: {
                        isShowingDialog = true
                    }) {
                        Label("Delete All", systemImage: "trash")
                    }.disabled(deckController.selectedDeck.players.isEmpty)
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                        .padding()
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .confirmationDialog(
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
            .padding(0.0)
            .background(SettingsController.shared.backgroundColor)
            .foregroundColor(SettingsController.shared.textColor)
        }
        .sheet(isPresented: $presentEditDeck) { // Present edit deck sheet
            EditDeckView(isPresented: $presentEditDeck, deck: $deckController.selectedDeck)
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
