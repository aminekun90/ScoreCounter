//
//  GameScene.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 24/02/2024.
//


import SpriteKit

final class GameScene: SKScene {

    private var dices = [DiceNode]()
    
    override func didMove(to view: SKView) {
        createDice(at: view.center)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let touch = touches.first else { return }
        let position = touch.location(in: self)

        let node = atPoint(position)
        if shuffleIfTouched(node: node) == false {
            if closestChild(point: position, maxDistance: 120) == nil {
                createDice(at: position)
            }
        }
    }

    override func didChangeSize(_ oldSize: CGSize) {
        children.forEach { node in
            node.position = CGPoint(x: node.position.x / oldSize.width * frame.size.width, y: node.position.y / oldSize.height * frame.size.height)
        }
    }

    private func createDice(at point: CGPoint, size: CGSize = CGSize(width: 100, height: 100)) {
        let dice = DiceNode(size: size)
        dice.position = point
        dices.append(dice)
        addChild(dice)
    }

    private func shuffleIfTouched(node: SKNode) -> Bool {
        let nodeCanBeShuffled = [NodeType.dimple.rawValue, NodeType.dot.rawValue, NodeType.dice.rawValue].contains(node.name)

        guard nodeCanBeShuffled else { return false }
        dices.first { $0 === node.parent }?.shuffle()
        return true
    }

}

// MARK: - ShakeDetectable

extension GameScene: ShakeDetectable {

    func shake() {
        dices.forEach { $0.shuffle() }
    }

}
