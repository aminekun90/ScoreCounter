//
//  DiceNode.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 24/02/2024.
//

import SpriteKit
import UIKit

final class DiceNode: SKShapeNode {

    // MARK: Constants

    private struct Constants {

        static let dotRadiusMultiplier: CGFloat = 0.10
        static let numberOfRows: CGFloat = 0.3
        static let dimpleInsetMultiplier: CGFloat = 0.11
        static let dotsInsetMultiplier: CGFloat = 0.08

    }

    // MARK: Variables

    private var dotRadius: CGFloat = .zero
    private var dimpleFrame: CGRect = .zero
    private var dotsFrame: CGRect = .zero
    private var dotNodes = [SKShapeNode]()
    public var side = DiceRepresentationModel(diceSide: DiceSide.allCases.randomElement() ?? .one)
    
    private var randomSide: DiceSide {
        return DiceSide.allCases.randomElement() ?? .one
    }

    private var dotTextureCached: SKTexture?

    // MARK: Initializer

    convenience init(size: CGSize) {
        self.init()
        self.init(rectOf: size, cornerRadius: size.width * 0.2)

        setup()
        draw()
    }

    // MARK: Draw

    func draw(_ side: DiceRepresentationModel? = nil) {
        self.side = side ?? DiceRepresentationModel(diceSide: randomSide)
        let shift = dotsFrame.width * Constants.numberOfRows

        let initialPoint = CGPoint(x: -shift, y: shift)
        var currentPoint = initialPoint

        for row in self.side.rows {
            for dot in row {
                if dot == 1 {
                    drawDot(at: currentPoint)
                }
                currentPoint.x += shift
            }
            currentPoint.x = initialPoint.x
            currentPoint.y -= shift
        }
    }

    private func setup() {
        fillColor = .white
        strokeColor = .lightGray

        let topColor = #colorLiteral(red: 0.8705882353, green: 0.8862745098, blue: 0.8901960784, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1)
        #if os(iOS)
        
        fillTexture = SKTexture(size: frame.size, color1: .white, color2: CIColor(color: bottomColor), direction: .down)
        #endif

        dimpleFrame = frame.insetBy(dx: frame.width * Constants.dimpleInsetMultiplier, dy: frame.height * Constants.dimpleInsetMultiplier)
        dotsFrame = dimpleFrame.insetBy(dx: dimpleFrame.width * Constants.dotsInsetMultiplier, dy: dimpleFrame.height * Constants.dotsInsetMultiplier)
        dotRadius = dimpleFrame.width * Constants.dotRadiusMultiplier

        let dimple = SKShapeNode(rectOf: dimpleFrame.size, cornerRadius: dimpleFrame.width * 0.4)
        dimple.fillColor = topColor
        dimple.strokeColor = topColor
        dimple.name = NodeType.dimple.rawValue
        addChild(dimple)
    }

    private func drawDot(at position: CGPoint) {
        let dot = SKShapeNode(circleOfRadius: dotRadius)
        dot.position = position
        dot.fillColor = .darkGray
        dot.lineWidth = 0.1
        dot.strokeColor = .black
        #if os(iOS)
        dot.fillTexture = dotTexture(size: dotsFrame.size)
        #endif
        dot.name = NodeType.dot.rawValue
        dotNodes.append(dot)
        addChild(dot)
    }

    #if os(iOS)
    private func dotTexture(size: CGSize) -> SKTexture {
        guard let dotTextureCached = dotTextureCached else {
            let dotTextureCached = SKTexture(size: size, color1: .black, color2: CIColor(color: .lightGray))
            self.dotTextureCached = dotTextureCached
            return dotTextureCached
        }

        return dotTextureCached
    }
    #endif

    private func performRollAnimation() {
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.05)
        let scaleDown = SKAction.scale(to: 1, duration: 0.1)
        let roll = SKAction.customAction(withDuration: 0, actionBlock: { [weak self] dice, _ in
            self?.redrawDice(dice)
        })
        let playRollSound = SKAction.playSoundFileNamed("dice_roll", waitForCompletion: false)
        let sequence = SKAction.sequence([scaleUp, roll, playRollSound, scaleDown])
        run(sequence)
    }

    private func redrawDice(_ dice: SKNode) {
        dotNodes.forEach { $0.removeFromParent() }
        (dice as? DiceNode)?.draw()
        EventBus.shared.publish(event: .diceShuffle("dice shuffle",self.side))
    }

    func shuffle() {
        performRollAnimation()
    }

}

