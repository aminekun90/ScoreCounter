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
          skView.showsFPS = true // Show frames per second in debug mode
          skView.showsNodeCount = true // Show node count in debug mode
          #endif
          skView.contentMode = .center // Content alignment
          
          // Create a new GameScene with the appropriate size
          let gameScene = GameScene(size: view.frame.size)
          scene = gameScene // Assign to the `scene` property
          
          skView.presentScene(scene) // Present the scene in the SKView
          
          view = skView // Set the SKView as the main view of the UIViewController
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
