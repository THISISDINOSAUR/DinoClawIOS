//Roar

import SceneKit

class ClawTraversalAssemblyNode: EntityNode {
    
    lazy var clawAssemblyNode = ClawAssemblyNode()
    lazy var leftRightRailNode: EntityNode = {
        let length: CGFloat = 10.0
        let box = SCNBox(width: 0.2, height: 0.2, length: 10.0, chamferRadius: 0)
        let node = EntityNode()
        node.geometry = box
        box.firstMaterial?.specular.contents = UIColor.white
        box.firstMaterial?.diffuse.contents = UIColor(hueDegrees: 47, saturation: 0, brightness: 0.5, alpha: 1.0)
        
        let boxShape = SCNPhysicsShape(geometry: box, options: nil)
        let boxBody = SCNPhysicsBody(type: .static, shape: boxShape)
        node.physicsBody = boxBody
        
        return node
    }()
    
    lazy var forwardBackwardRailNode: EntityNode = {
        let length: CGFloat = 10.0
        let box = SCNBox(width: 0.2, height: 0.2, length: 10.0, chamferRadius: 0)
        let node = EntityNode()
        node.geometry = box
        box.firstMaterial?.specular.contents = UIColor.white
        box.firstMaterial?.diffuse.contents = UIColor(hueDegrees: 47, saturation: 0, brightness: 0.5, alpha: 1.0)
        
        let boxShape = SCNPhysicsShape(geometry: box, options: nil)
        let boxBody = SCNPhysicsBody(type: .static, shape: boxShape)
        node.physicsBody = boxBody
        node.eulerAngles.y = Float(90.degreesToRadians)
        
        return node
    }()
    
    override init() {
        super.init()
        
        addChildNode(clawAssemblyNode)
        addChildNode(leftRightRailNode)
        addChildNode(forwardBackwardRailNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setClawPosition(x: Float, z: Float) {
        clawAssemblyNode.position = SCNVector3(x, clawAssemblyNode.position.y, z)
        leftRightRailNode.position = SCNVector3(x, leftRightRailNode.position.y, leftRightRailNode.position.z)
        forwardBackwardRailNode.position = SCNVector3(forwardBackwardRailNode.position.x, forwardBackwardRailNode.position.y, z)
    }
}
