//
//  CGPoint+Distance.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 24/02/2024.
//

import Foundation

import CoreGraphics

extension CGPoint {

    func distance(_ point: CGPoint) -> CGFloat {
        return CGFloat(hypotf(Float(point.x - x), Float(point.y - y)))
    }

}
