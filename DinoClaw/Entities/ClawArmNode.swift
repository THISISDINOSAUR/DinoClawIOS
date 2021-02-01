//Roar

import SceneKit

class ClawArmNode: EntityNode {
    
    override init() {
        let length: CGFloat = 1.5
        let box = SCNBox(width: 0.2, height: length, length: 0.08, chamferRadius: 0)
        super.init()
        geometry = box
        box.firstMaterial?.specular.contents = UIColor.white
        box.firstMaterial?.diffuse.contents = UIColor(hueDegrees: 47, saturation: 0, brightness: 0.5, alpha: 1.0)
        
        let boxShape = SCNPhysicsShape(geometry: box, options: nil)
        let boxBody = SCNPhysicsBody(type: .static, shape: boxShape)
        physicsBody = boxBody
        
        pivot = SCNMatrix4MakeTranslation(0, 0.49, 0)
        
        let secondlength: CGFloat = 1.0
        let secondBox = SCNBox(width: 0.2, height: secondlength, length: 0.08, chamferRadius: 0)
        let node = SCNNode(geometry: secondBox)
        secondBox.firstMaterial?.specular.contents = UIColor.white
        secondBox.firstMaterial?.diffuse.contents = UIColor(hueDegrees: 47, saturation: 0, brightness: 0.5, alpha: 1.0)
        
        let secondBoxShape = SCNPhysicsShape(geometry: secondBox, options: nil)
        let secondBoxBody = SCNPhysicsBody(type: .static, shape: secondBoxShape)
        node.physicsBody = secondBoxBody
        node.pivot = SCNMatrix4MakeTranslation(0, Float(secondlength / 2.0), 0)
        node.position = SCNVector3(0, -length / 2.0, 0)
        node.eulerAngles.x = Float(-70.degreesToRadians)
        
        addChildNode(node)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
