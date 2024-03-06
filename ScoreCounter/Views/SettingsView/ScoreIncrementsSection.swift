//
//  ScoreIncrementsSection.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 05/03/2024.
//

import Foundation
import SwiftUI

struct IncrementRow: View {
    @Binding var incrementValue: Int64
    var onRemove: () -> Void
    
    var body: some View {
        HStack {
            TextField("Increment Value", value: $incrementValue, formatter: NumberFormatter())
                .keyboardType(.numberPad)
            
            Button(action: {
                // Remove button
                onRemove()
            }) {
                Image(systemName: "trash.fill").foregroundColor(.red)
            }
        }
    }
}

struct ScoreIncrementsSection: View {
    @Binding var increments: IncrementsArray
    var removeIncrement: ( Int) -> Void
    var appendIncrement: ( Int64) -> Void

    var body: some View {
        Section(header: Text("Score Increments")) {
            ForEach(increments.values.indices, id: \.self) { index in
                IncrementRow(
                    incrementValue: $increments.values[index],
                    onRemove: {
                        removeIncrement(index)
                    }
                )
            }

            Button(action: {
                // Add new score increment
                appendIncrement(0)
            }) {
              
                Text("Add increment")
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.green)
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}
