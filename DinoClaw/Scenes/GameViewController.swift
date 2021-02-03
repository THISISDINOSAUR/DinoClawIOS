//
//  GameViewController.swift
//  DinoClaw
//
//  Created by Elle Sullivan on 31/01/2021.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GameViewController: UIViewController {
    
    private var scene: SCNScene!
    private var scnView: SCNView {
        self.view as! SCNView
    }
    private var spriteKitScene: SKScene!
    
    private var previousFrameTime: TimeInterval?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        scene = SCNScene(named: "art.scnassets/world.scn")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 25)
        
        // main "sun" light
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .directional
        lightNode.light!.castsShadow = true
        lightNode.light!.intensity = GameplayConfiguration.World.Lights.Directional.intensity
        lightNode.light!.color = GameplayConfiguration.World.Lights.Directional.color
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        lightNode.eulerAngles = GameplayConfiguration.World.Lights.Directional.rotation
        scene.rootNode.addChildNode(lightNode)
        
        // ambient lighting
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light?.intensity = 700
        ambientLightNode.light!.color = GameplayConfiguration.World.Lights.Ambient.color
        scene.rootNode.addChildNode(ambientLightNode)
        
        let ambientLightNode2 = SCNNode()
        ambientLightNode2.light = SCNLight()
        ambientLightNode2.light!.type = .directional
        ambientLightNode2.light?.intensity = 230
        ambientLightNode2.eulerAngles = SCNVector3(x: Float(180.degreesToRadians), y: 0, z: 0)
        ambientLightNode2.light!.color = GameplayConfiguration.World.Lights.Ambient.color
        scene.rootNode.addChildNode(ambientLightNode2)
        
        
        
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.backgroundColor = UIColor.black
        scnView.pointOfView = cameraNode
        
        if GameplayConfiguration.Debug.isDrawingOn {
            //scnView.debugOptions = [.showPhysicsShapes, .showCameras, .showConstraints, .showPhysicsFields]
        }
        scnView.showsStatistics = false
        
        spriteKitScene = SKScene(size: scnView.bounds.size)
        scnView.overlaySKScene = spriteKitScene
        scnView.overlaySKScene!.scaleMode = .resizeFill
        scnView.overlaySKScene!.isUserInteractionEnabled = true
        
        scnView.delegate = self
        
        let cabinetNode = ClawMachineCabinetNode()
        scene.rootNode.addChildNode(cabinetNode)
        
        
        
        for _ in 0..<50 {
            let ball = SCNSphere(radius: 1.0)
            let node = SCNNode(geometry: ball)
            ball.firstMaterial?.diffuse.contents = UIColor(hueDegrees: CGFloat(Float.random(in: 0..<360)), saturation: 1.0, brightness: 1.0, alpha: 1.0)
            
            let boxShape = SCNPhysicsShape(geometry: ball, options: nil)
            let boxBody = SCNPhysicsBody(type: .dynamic, shape: boxShape)
            node.physicsBody = boxBody
            node.position = SCNVector3(Float.random(in: -4..<4), 5, Float.random(in: -4..<4))
            
            scene.rootNode.addChildNode(node)
        }
        
        setUpButtons()
    }
    
    func setUpButtons() {
        let size = view.frame.size
        let color = UIColor(hueDegrees: 350, saturation: 0.4, brightness: 1.0, alpha: 1.0)
        
        let forwardButton = UIButton()
        forwardButton.frame = CGRect(x: size.width - 100, y: size.height - 100, width: 50, height: 50)
        forwardButton.backgroundColor = color
        forwardButton.layer.cornerRadius = 25
        forwardButton.alpha = 0.5
        scnView.addSubview(forwardButton)
        forwardButton.addTarget(self, action: #selector(self.forwardButtonPressed), for: UIControl.Event.touchDown)
        
        let rightButton = UIButton()
        rightButton.frame = CGRect(x: forwardButton.frame.minX - 75, y: size.height - 100, width: 50, height: 50)
        rightButton.backgroundColor = color
        rightButton.layer.cornerRadius = 25
        rightButton.alpha = 0.5
        scnView.addSubview(rightButton)
        rightButton.addTarget(self, action: #selector(self.rightButtonPressed), for: UIControl.Event.touchDown)
    }
    
    @objc
    func forwardButtonPressed() {
        //TODO this is gonna need to be a hold down situation
    }
    
    @objc
    func rightButtonPressed() {
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
}

extension GameViewController: SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let previousFrameTime = previousFrameTime else {
            self.previousFrameTime = time
            return
        }
        let deltaTime = time - previousFrameTime
        self.previousFrameTime = time
        
        for node in scene.rootNode.traverse() {
            if let entity = node as? EntityNode {
                entity.update(deltaTime: deltaTime)
            }
        }
    }
}
