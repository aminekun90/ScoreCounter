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
    @State var currentPage:Page = Page.counter
    @State private var appSettings = AppSettings()
    
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                
                switch currentPage {
                case .counter:
                    PlayersView()
                case .dice:
                    GameViewWrapper()
                case .settings:
                    SettingsView(settings: $appSettings)
                }
                BottomTaskBar(currentPage: $currentPage)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
