//Roar

import SceneKit

class ClawNode: EntityNode {
    
    lazy var arms = [ClawArmNode(), ClawArmNode(), ClawArmNode()]
    
    override init() {
        let box = SCNCylinder(radius: 0.3, height: 0.3)
        super.init()
        geometry = box
        box.firstMaterial?.specular.contents = UIColor.white
        box.firstMaterial?.diffuse.contents = UIColor(hueDegrees: 47, saturation: 0, brightness: 1.0, alpha: 1.0)
        
        let boxShape = SCNPhysicsShape(geometry: box, options: nil)
        let boxBody = SCNPhysicsBody(type: .static, shape: boxShape)
        physicsBody = boxBody
        
        for (i, arm) in arms.enumerated() {
            addChildNode(arm)
            arm.position = SCNVector3.pointOnGroundCircle(radius: 0.2, degrees: 120.0 * Float(i) - 90, center: SCNVector3(0, -0.3, 0))
            arm.eulerAngles.x = Float(35.degreesToRadians)
            arm.eulerAngles.y = Float(i) * Float(-120.degreesToRadians)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
