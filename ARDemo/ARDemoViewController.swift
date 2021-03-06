//
//  ARDemoViewController.swift
//  ARDemo
//
//  Created by Raj Sathi on 8/22/19.
//  Copyright © 2019 Raj. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARDemoViewController: UIViewController, ARSKViewDelegate {

    var sceneView: ARSKView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view: ARSKView = self.view as? ARSKView {
            sceneView = view
            sceneView?.delegate = self

            // Initialize our Sprite Kit scene and then present it using our ARSKView
            let scene: ARDemoScene = ARDemoScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)

            view.presentScene(scene)
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSKViewDelegate
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {

        // Callback to create SpriteKit nodes for the anchors created in the Scene View
        // See ARDemoSceneView.update() for where the anchors are created using object
        // detection
        let labelNode = SKLabelNode(fontNamed: ApplicationFonts.labelFontName())
        labelNode.fontColor = ApplicationColors.textColor()
        labelNode.fontSize = ApplicationFonts.labelFontSize()
        labelNode.color = UIColor.clear

        let currentSceneView: ARDemoScene = sceneView!.scene as! ARDemoScene
        if let anchorName: String = currentSceneView.anchorNames[anchor.identifier] {
            labelNode.text = anchorName
        }

        let labelFrame: CGRect = labelNode.frame
        labelNode.position = CGPoint(x:0, y: -((labelFrame.size.height / 2) - 1.0));

        // You can't directly supply a background color to a SKLabelNode so add a SKShapeNode
        // to provide a background color
        var backgroundColor: UIColor = ApplicationColors.detectLabelBackgroundColor()
        if currentSceneView.sceneViewMode == .displayMode {
            backgroundColor = ApplicationColors.randomLabelBackgroundColor()
        }
        
        let backgroundColorNode: SKShapeNode = SKShapeNode(rectOf: CGSize(width: labelFrame.width, height: labelFrame.height))
        backgroundColorNode.fillColor = backgroundColor
        backgroundColorNode.strokeColor = backgroundColor
        backgroundColorNode.position = CGPoint(x: 200, y: 100)

        backgroundColorNode.addChild(labelNode)

        return backgroundColorNode
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
    }

    func sessionWasInterrupted(_ session: ARSession) {
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        sceneView.session.run(session.configuration!, options: [.resetTracking, .removeExistingAnchors])
    }
}
