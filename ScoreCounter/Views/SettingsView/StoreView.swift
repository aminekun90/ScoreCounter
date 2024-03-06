//
//  StoreView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 05/03/2024.
//

import Foundation
import SwiftUI
import StoreKit

struct StoreView: View {
    @Binding var isPresented: Bool
    var body: some View {
 
            VStack {
                HStack{
                    Text("Keep the app ad-free 🙏")
                        .font(.title)
                }
               

                ProductView(id: "com.aminekun90.plus.subscription") {
                    Image(systemName: "crown")
                }
                .productViewStyle(.compact)
                .padding()
            }
       
       
    }
}
