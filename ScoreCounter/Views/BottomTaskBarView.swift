//
//  BottomTaskBarView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 23/02/2024.
//

import Foundation
import SwiftUI

struct BottomTaskBar: View {
    @Binding var currentPage:Page
    var body: some View {
        HStack {
            Button(action: {
                // Handle left button action
                currentPage = Page.counter
            }) {
                Text("123")
            }
            .padding()

            Spacer()

            Button(action: {
                // Handle middle button action
                currentPage = Page.dice
            }) {
                Image(systemName: "dice")
                    .imageScale(.large)
            }
            .padding()

            Spacer()

            Button(action: {
                // Handle right button action
                currentPage = Page.settings
            }) {
                Image(systemName: "gear")
                    .imageScale(.large)
            }
            .padding()
        }
        .background(Color.green) // Set the background color as needed
        .foregroundColor(.white)
    }
}
