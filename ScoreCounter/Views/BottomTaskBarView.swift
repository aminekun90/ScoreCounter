//
//  BottomTaskBarView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 23/02/2024.
//

import Foundation
import SwiftUI

struct BottomTaskBar: View {
    var body: some View {
        HStack {
            Button(action: {
                // Handle left button action
                print("Left button tapped")
            }) {
                Text("123")
            }
            .padding()

            Spacer()

            Button(action: {
                // Handle middle button action
                print("Robot icon tapped")
            }) {
                Image(systemName: "dice")
                    .imageScale(.large)
            }
            .padding()

            Spacer()

            Button(action: {
                // Handle right button action
                print("Cog icon tapped")
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
