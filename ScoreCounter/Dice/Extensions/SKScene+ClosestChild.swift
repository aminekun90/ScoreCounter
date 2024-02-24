//
//  SKScene+ClosestChild.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 24/02/2024.
//

import Foundation
import SpriteKit

extension SKScene {

    func closestChild(point: CGPoint, maxDistance: CGFloat) -> SKNode? {
        return self
            .children
            .filter { $0.position.distance(point) <= maxDistance }
            .min { $0.position.distance(point) > $1.position.distance(point) }
    }

}
