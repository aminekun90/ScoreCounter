//
//  ContentView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 21/02/2024.
//

import SwiftUI
enum Page {
    case counter
    case dice
    case settings
}

struct GameViewWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = GameViewController

    func makeUIViewController(context: Context) -> GameViewController {
        return GameViewController()
    }

    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {
        // Update any properties or handle updates here
    }
}

struct ContentView: View {
    
    @State var currentPage: Page = Page.counter
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                switch currentPage {
                case .counter:
                    PlayersView()
                case .dice:
                    GameViewWrapper().overlay(VStack {
                        DiceActionBarView()
                            .frame(maxHeight: .infinity, alignment: .top)
                    }.ignoresSafeArea(.all, edges: .bottom))
                case .settings:
                    SettingsView()
                }
                BottomTaskBar(currentPage: $currentPage)
            }.frame(maxWidth: .infinity,maxHeight: .infinity)
        }
    }
   
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

