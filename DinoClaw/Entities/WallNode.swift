//Roar

import SceneKit

class WallNode: EntityNode {
    
    override init() {
        let box = SCNBox(width: 10, height: 10, length: 0.2, chamferRadius: 0)
        super.init()
        geometry = box
        box.firstMaterial?.specular.contents = UIColor.white
        box.firstMaterial?.diffuse.contents = UIColor(hueDegrees: 47, saturation: 0, brightness: 1.0, alpha: 0.2)
        
        let boxShape = SCNPhysicsShape(geometry: box, options: nil)
        let boxBody = SCNPhysicsBody(type: .static, shape: boxShape)
        physicsBody = boxBody
        
        castsShadow = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
