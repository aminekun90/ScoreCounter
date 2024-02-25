//
//  ColorSchemeObserver.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 24/02/2024.
//

import Foundation
import SwiftUI
struct ColorSchemeObserver: ViewModifier {
    @State private var currentColorScheme: ColorScheme?

    func body(content: Content) -> some View {
        content
            .background(
                Color.clear
                    .onChange(of: colorScheme) { newColorScheme in
                        guard let currentColorScheme = currentColorScheme else {
                            self.currentColorScheme = newColorScheme
                            return
                        }

                        if newColorScheme != currentColorScheme {
                            self.currentColorScheme = newColorScheme
                            // Handle color scheme change here
                        }
                    }
            )
    }
}
