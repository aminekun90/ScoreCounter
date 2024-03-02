//
//  DeckRow.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 29/02/2024.
//

import Foundation
import SwiftUI

struct DeckRowView: View {
    @State private var showAlert = false
    
    var isSelected: Bool
    var title: String
    var action: () -> Void
    var removeAction: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading) {
                HStack(spacing: 20) {
                    Rectangle()
                        .fill(isSelected ? .purple : .white)
                        .frame(width: 5)
                    Text(title)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(isSelected ? .black : .gray)
                    Spacer()
                }
                .onTapGesture {
                    action()
                }
                
            }
            
            Spacer()
            
            Button(action: {
                showAlert = true
            }) {
                Image(systemName: "trash")
                    .padding(7)
                    .imageScale(.medium)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .background(.red)
                    .foregroundColor(.white)
            }
            .cornerRadius(10)
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Confirm Removal"),
                    message: Text("Are you sure you want to remove this item?"),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(Text("Remove")) {
                        removeAction()
                    }
                )
            }
        }
        .frame(height: 50)
        .background(
            LinearGradient(colors: [isSelected ? Color.purple.opacity(0.5) : Color.white.opacity(0), .white], startPoint: .leading, endPoint: .trailing)
        )
    }
}
