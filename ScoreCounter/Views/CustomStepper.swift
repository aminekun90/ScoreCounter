//
//  CustomStepper.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 04/03/2024.
//

import Foundation
import SwiftUI
struct CustomStepper: View {
    @Binding var value: Int
    var hideLabel: Bool
    var onIncrement: () -> Void
    var onDecrement: () -> Void

    init(value: Binding<Int>,hideLabel:Bool=false, onIncrement: @escaping () -> Void, onDecrement: @escaping () -> Void) {
        self._value = value
        self.hideLabel = hideLabel
        self.onIncrement = onIncrement
        self.onDecrement = onDecrement
    }

    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                // Decrement
                onDecrement()
            }) {
                Image(systemName: "minus.circle")
                    .font(.system(size: 30))
            }.padding(20).imageScale(.large)
            
            if(!hideLabel){
                Text("\(value)")
            }
            

            Button(action: {
                // Increment
                onIncrement()
            }) {
                Image(systemName: "plus.circle")
                    .font(.system(size: 30)).imageScale(.large)
            }.padding(20)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(30)
        .cornerRadius(10)
    }
}

