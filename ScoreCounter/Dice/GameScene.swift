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
    private let maxDices = 20
    private var text = SKLabelNode()
    private var cancellables = Set<AnyCancellable>() 
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupEventSubscription()
        }

        override init(size: CGSize) {
            super.init(size: size)
            setupEventSubscription()
        }
    
     private func setupEventSubscription() {
         EventBus.shared.eventPublisher
             .sink { [weak self] event in
                 guard let self = self else { return }

                 switch event {
                     
                 case .updateDices(_,let numberOfDices):
                     dices.removeAll()
                     removeAllChildren()
                     for _ in 0..<numberOfDices {
                        createDice()
                    }
                     
                 case .diceShuffled(_,_):
                     updateSum()
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

    func createDice(at point: CGPoint? = nil, size: CGSize = CGSize(width: 100, height: 100)) {
            if dices.count >= maxDices {
                print("Cannot add more than \(maxDices) dices")
                return
            }

            let dice = DiceNode(size: size)
            
            if dices.isEmpty {
                // Default position for the first dice
                dice.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            } else if let point = point {
                dice.position = point
            } else {
                // Position the new dice around the first dice
                let firstDice = dices[0]
                let angle = (CGFloat(dices.count) / CGFloat(maxDices)) * 2 * .pi // Determine position based on angle
                let radius: CGFloat = 150 // Distance from the center dice
                
                let newPosition = CGPoint(
                    x: firstDice.position.x + radius * cos(angle),
                    y: firstDice.position.y + radius * sin(angle)
                )

                dice.position = newPosition
            }

            dices.append(dice)
            addChild(dice)
        
            
            if !children.contains(text){
                addChild(text) // Add to the scene
                
                text.fontName = "Oswald-Bold"
                text.fontSize = 20
                text.fontColor = .white
                
                // Position the text below the dice with some space
                text.position = CGPoint(x: dice.position.x, y: dice.position.y - 250) // Adjusted position
                    }
            updateSum()
        }
    func updateSum() {
           let sum = dices.reduce(0) { result, dice in
               result + dice.side.getSideValue() // Sum of all dice
           }

        let components = dices.map { "\($0.side.getSideValue())" }
        let sumText = dices.count < 11 ? "\(sum) : " + components.joined(separator: "+"):"\(sum) :\(randomEmoji())\(randomEmoji())\(randomEmoji())\(randomEmoji()) "
           
        text.text = dices.count > 1 ? sumText : "\(sum)"      
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
