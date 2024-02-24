//
//  SceneCreator.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 24/02/2024.
//
import SpriteKit

struct SceneCreator {

    static func create(scene: SKScene, size: CGSize) -> SKScene {
        scene.size = size
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .black
        return scene
    }

}
