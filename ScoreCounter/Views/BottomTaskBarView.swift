//
//  BottomTaskBarView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 23/02/2024.
//

import Foundation
import SwiftUI

struct BottomTaskBar: View {
    @Binding var currentPage: Page

    var body: some View {
        HStack {
            NavigationButton("123", page: .counter)
            Spacer()
            ImageButton(systemName: "dice", page: .dice)
            Spacer()
            ImageButton(systemName: "gearshape", page: .settings)
        }
        .background(SettingsController.shared.backgroundColor)
    }

    @ViewBuilder
    private func NavigationButton(_ text: String, page: Page) -> some View {
        Button(action: {
            currentPage = page
        }) {
            Text(text)
                .font(.custom("Micro5-Regular", size: 30))
        }
        .padding()
        .foregroundColor(foregroundColor(for: page))
    }

    @ViewBuilder
    private func ImageButton(systemName: String, page: Page) -> some View {
        Button(action: {
            currentPage = page
            vibratePhone()
        }) {
            Image(systemName: systemName)
                .imageScale(.large)
        }
        .padding()
        .foregroundColor(foregroundColor(for: page))
    }

    private func foregroundColor(for page: Page) -> Color {
        return currentPage == page ? .selectedColor : SettingsController.shared.textColor
    }
}

extension Color {
    static var selectedColor: Color {
        return Color.blue
    }
}

struct BottomTaskBar_Previews: PreviewProvider {
    @State static var currentPage: Page = Page.counter
    static var previews: some View {
        BottomTaskBar(currentPage: $currentPage)
    }
}
