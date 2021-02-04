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
    
    var cabinetNode: ClawMachineCabinetNode!
    var startButton: UIButton!
    var forwardButton: UIButton!
    var rightButton: UIButton!

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
        
        cabinetNode = ClawMachineCabinetNode()
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
        let color = UIColor(hueDegrees: 334, saturation: 0.43, brightness: 1.0, alpha: 1.0)
        
        startButton = UIButton()
        startButton.frame = CGRect(x: size.width - 250, y: size.height - 75, width: 50, height: 50)
        startButton.backgroundColor = color
        startButton.layer.cornerRadius = 25
        scnView.addSubview(startButton)
        startButton.addTarget(self, action: #selector(self.startButtonPressed), for: UIControl.Event.touchDown)
        
        forwardButton = UIButton()
        forwardButton.frame = CGRect(x: size.width - 150, y: size.height - 75, width: 50, height: 50)
        forwardButton.backgroundColor = color
        forwardButton.layer.cornerRadius = 25
        scnView.addSubview(forwardButton)
        forwardButton.addTarget(self, action: #selector(self.forwardButtonPressed), for: UIControl.Event.touchDown)
        //tODO needs to nbe any kind of touch up event
        forwardButton.addTarget(self, action: #selector(self.forwardButtonUnpressed), for: UIControl.Event.touchUpInside)
        
        rightButton = UIButton()
        rightButton.frame = CGRect(x: forwardButton.frame.maxX + 50, y: size.height - 75, width: 50, height: 50)
        rightButton.backgroundColor = color
        rightButton.layer.cornerRadius = 25
        scnView.addSubview(rightButton)
        rightButton.addTarget(self, action: #selector(self.rightButtonPressed), for: UIControl.Event.touchDown)
        rightButton.addTarget(self, action: #selector(self.rightButtonUnpressed), for: UIControl.Event.touchUpInside)
    }
    
    @objc
    func startButtonPressed() {
        cabinetNode.startButtonPressed()
    }
    
    @objc
    func forwardButtonPressed() {
        cabinetNode.forwardButtonPressed()
    }
    
    @objc
    func forwardButtonUnpressed() {
        cabinetNode.forwardButtonUnpressed()
    }
    
    @objc
    func rightButtonPressed() {
        cabinetNode.rightButtonPressed()
    }
    
    @objc
    func rightButtonUnpressed() {
        cabinetNode.rightButtonUnpressed()
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
        
        startButton.alpha = 0.5
        forwardButton.alpha = 0.5
        rightButton.alpha = 0.5
        let state = cabinetNode.stateMachine.currentState
        if state is ClawMachineReadyToStartState {
            startButton.alpha = 1.0
        } else if state is ClawMachineAwaitingForwardInputState || state is ClawMachineMovingForwardState {
            forwardButton.alpha = 1.0
        } else if state is ClawMachineAwaitingRightInputState || state is ClawMachineMovingRightState {
            rightButton.alpha = 1.0
        }
    }
}
