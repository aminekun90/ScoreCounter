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

struct ContentView: View {
    @State var currentPage:Page = Page.counter
    
    let sqliteService = SqliteService()

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                switch currentPage {
                case .counter:
                    PlayersView()
                case .dice:
                    ScrollView {
                        
                        Text("Dice")
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                case .settings:
                    ScrollView {
                        Text("Settings")
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
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
