//
//  GameScene.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 24/02/2024.
//


import SpriteKit
import Combine

final class GameScene: SKScene {

    private var dices = [DiceNode]()
    private var text = SKLabelNode()
    private var cancellables = Set<AnyCancellable>() 
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupEventSubscription() // Set up Combine subscription here
        }

        override init(size: CGSize) {
            super.init(size: size)
            setupEventSubscription() // Set up Combine subscription here
        }
    // Setting up the Combine subscription
     private func setupEventSubscription() {
         EventBus.shared.eventPublisher
             .sink { [weak self] event in
                 guard let self = self else { return }

                 switch event {
                 case .diceShuffled(_, let dice):
                     self.text.text = "\(dice.getSideValue())"
                     break
                 case .shuffleDiceAction:
                     dices.forEach { $0.shuffle() }
                     break
                 default:
                     break
                 }
             }
             .store(in: &cancellables) // Keep the subscription to avoid deallocation
     }
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
//                createDice(at: position)// commented
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
        // Create a label node to display text
        self.text = SKLabelNode(text: "\(dice.side.getSideValue())")
        
        self.text.fontName = "Helvetica"     // Font type
        self.text.fontSize = 20              // Smaller font size
        self.text.fontColor = .white         // Text color

        // Position the label below the dice
        text.position = CGPoint(x: dice.position.x, y: dice.position.y - 120) // Adjust as needed
        addChild(text) // Add the label to the scene
    }

    private func shuffleIfTouched(node: SKNode) -> Bool {
        // shuffle all dices
        dices.forEach { $0.shuffle() }
        // let nodeCanBeShuffled = [NodeType.dimple.rawValue, NodeType.dot.rawValue, NodeType.dice.rawValue].contains(node.name)
        //dices.first?.shuffle()//first is shuffled
        
        // uncomment if you want to shuffle the touced dice
//        guard nodeCanBeShuffled else { return false }
//        dices.first { $0 === node.parent }?.shuffle()
        return true
    }

}

// MARK: - ShakeDetectable

extension GameScene: ShakeDetectable {

    func shake() {
        dices.forEach { $0.shuffle() }
    }

}
