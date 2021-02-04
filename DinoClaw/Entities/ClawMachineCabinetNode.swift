//Roar

import SceneKit
import GameplayKit

//enum ClawMachineCabinetState {
//    case readyTostart
//    case awaitingForwardInput
//    case movingForward
//    case awaitingRightInput
//    case movingRight
//    case loweringClaw
//    case raisingClaw
//    case returningToStart
//    case openingClaw
//}

class ClawMachineCabinetNode: EntityNode {
    
    lazy var stateMachine: GKStateMachine = {
        let states = [
            ClawMachineReadyToStartState(clawMachineNode: self),
            ClawMachineAwaitingForwardInputState(clawMachineNode: self),
            ClawMachineMovingForwardState(clawMachineNode: self),
            ClawMachineAwaitingRightInputState(clawMachineNode: self),
            ClawMachineMovingRightState(clawMachineNode: self),
            ClawMachineLoweringClawState(clawMachineNode: self),
            ClawMachineRaisingClawState(clawMachineNode: self),
            ClawMachineReturningToStartState(clawMachineNode: self),
            ClawMachineOpeningClawState(clawMachineNode: self)
        ]
        let stateMachine = GKStateMachine(states: states)
        stateMachine.enter(ClawMachineReadyToStartState.self)
        return stateMachine
    }()
    
    lazy var floorNode: EntityNode = {
        let box = SCNBox(width: 10, height: 0.5, length: 10, chamferRadius: 0)
        let node = EntityNode()
        node.geometry = box
        box.firstMaterial?.specular.contents = UIColor.white
        box.firstMaterial?.diffuse.contents = UIColor(hueDegrees: 47, saturation: 0, brightness: 1.0, alpha: 1.0)
        
        let boxShape = SCNPhysicsShape(geometry: box, options: nil)
        let boxBody = SCNPhysicsBody(type: .static, shape: boxShape)
        node.physicsBody = boxBody
        return node
    }()
    
    lazy var walls: [WallNode] = {
        let wallHeight = 10.0
        let wallThickness = 0.2
        let wall = WallNode()
        wall.eulerAngles.y = Float(90.degreesToRadians)
        wall.position = SCNVector3(-5 + wallThickness / 2.0, wallHeight / 2.0, 0)
        
        let wall2 = WallNode()
        wall2.eulerAngles.y = Float(90.degreesToRadians)
        wall2.position = SCNVector3(5 - wallThickness / 2.0, wallHeight / 2.0, 0)
        
        let wall3 = WallNode()
        wall3.position = SCNVector3(0, wallHeight / 2.0, -5 + wallThickness / 2.0)
        
        let wall4 = WallNode()
        wall4.position = SCNVector3(0, wallHeight / 2.0, 5 - wallThickness / 2.0)
        return [wall, wall2, wall3, wall4]
    }()
    
    lazy var clawAssemblyNode: ClawTraversalAssemblyNode = {
        let clawAssembly = ClawTraversalAssemblyNode()
        clawAssembly.position = SCNVector3(0, 10, 0)
        clawAssembly.setClawPosition(x: -3.5, z: 3.5)
        return clawAssembly
    }()
    
    override init() {
        super.init()
        
        addChildNode(floorNode)
        for wall in walls {
            addChildNode(wall)
        }
        addChildNode(clawAssemblyNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startButtonPressed() {
        stateMachine.enter(ClawMachineAwaitingForwardInputState.self)
    }
    
    func forwardButtonPressed() {
        stateMachine.enter(ClawMachineMovingForwardState.self)
    }
    
    func forwardButtonUnpressed(){
        stateMachine.enter(ClawMachineAwaitingRightInputState.self)
    }
    
    func rightButtonPressed() {
        stateMachine.enter(ClawMachineMovingRightState.self)
    }
    
    func rightButtonUnpressed(){
        stateMachine.enter(ClawMachineLoweringClawState.self)
    }
}
