//
//  GameViewController.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 24/02/2024.
//

import UIKit
import SpriteKit

final class GameViewController: UIViewController {

    private var scene: SKScene?

    override func loadView() {
        super.loadView()

        let skView = SKView(frame: view.frame)
        skView.ignoresSiblingOrder = true
        #if DEBUG
        skView.showsFPS = true
        skView.showsNodeCount = true
        #endif
        skView.contentMode = .center
        scene = SceneCreator.create(scene: GameScene(), size: view.frameSize)
        skView.presentScene(scene)
        view = skView
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.current.userInterfaceIdiom == .phone ? .allButUpsideDown : .all
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        scene?.size = size
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)

        (scene as? ShakeDetectable)?.shake()
    }

}
