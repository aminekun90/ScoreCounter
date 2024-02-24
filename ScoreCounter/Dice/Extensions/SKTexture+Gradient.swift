//
//  SKTexture+Gradient.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 24/02/2024.
//

import Foundation
import SpriteKit

enum GradientDirection {
    case up
    case down
    case left
    case upLeft
    case upRight

}

extension SKTexture {

    convenience init(size: CGSize, color1: CIColor, color2: CIColor, direction: GradientDirection = .down) {
        let context = CIContext()
        guard let filter = CIFilter(name: "CILinearGradient") else {
            fatalError("Cannot create filter: 'CILinearGradient'")
        }

        let startVector: CIVector
        let endVector: CIVector
        filter.setDefaults()

        switch direction {
        case .up:
            startVector = CIVector(x: 0, y: 0)
            endVector = CIVector(x: 0, y: size.height)
        case .down:
            startVector = CIVector(x: 0, y: size.width)
            endVector = CIVector(x: 0, y: 0)
        case .left:
            startVector = CIVector(x: size.width, y: 0)
            endVector = CIVector(x: 0, y: 0)
        case .upLeft:
            startVector = CIVector(x: size.width, y: 0)
            endVector = CIVector(x: 0, y: size.height)
        case .upRight:
            startVector = CIVector(x: 0, y: 0)
            endVector = CIVector(x: size.width, y: size.height)
        }

        filter.setValue(startVector, forKey: "inputPoint0")
        filter.setValue(endVector, forKey: "inputPoint1")
        filter.setValue(color1, forKey: "inputColor0")
        filter.setValue(color2, forKey: "inputColor1")

        guard let filteredImage = filter.outputImage else {
            fatalError("Cannot create image from filter: \(filter).")
        }

        guard let image = context.createCGImage(filteredImage, from: CGRect(x: 0, y: 0, width: size.width, height: size.height)) else {
            fatalError("Cannot create image from context: \(context).")
        }

        self.init(cgImage: image)
    }

}
