//
//  EditWinningScoreView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 04/03/2024.
//

import Foundation
import SwiftUI

struct EditWinningScoreView: View {
    @Binding var isPresented: Bool
    @Binding var winningScore: Int
    @State private var winningScoreText: String = ""
    
    var body: some View {
        NavigationView {
           
                Section(header: Text("Winning Score")) {
                    VStack {
                        TextField("Enter Winning Score", text: $winningScoreText)
                            .font(.system(size:40))
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .onAppear {
                                vibratePhone()
                                winningScoreText = "\(winningScore)"
                            }
                            .onChange(of: winningScoreText) {
                                if let newScore = Int(winningScoreText) {
                                    winningScore = newScore
                                }
                            }.textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth:.infinity).padding(.top,30)
                       
                        CustomStepper(
                            value: $winningScore,
                            hideLabel:true,
                            onIncrement: {
                                vibratePhone()
                                winningScore += 1
                                winningScoreText = String(winningScore)
                            },
                            onDecrement: {
                                vibratePhone()
                                winningScore -= 1
                                winningScoreText = String(winningScore)
                            })
                        
                    }
                }
            .navigationTitle("Edit Winning Score")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    // Perform save action here
                    isPresented = false
                }
            )
        }
    }
}



struct EditWinningScoreView_Previews: PreviewProvider {
    
    @State static var isEditingWinningScore = false
    @State static var winningScore = 32
    static var previews: some View {
        EditWinningScoreView(
            isPresented: $isEditingWinningScore,
            winningScore: $winningScore)
    }
}
