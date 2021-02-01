//Roar

import SceneKit

class DirectionControlComponent: Component, AnalogStickInputDelegate {
    
    weak var parentNode: EntityNode?
    let scene: SCNScene
    var analogInputVector = CGVector.zero
    
    init(parentNode: EntityNode, scene: SCNScene) {
        self.parentNode = parentNode
        self.scene = scene
    }
    
    func analogStickInput(input inputVector: CGVector) {
        analogInputVector = inputVector
    }
    
    func update(deltaTime: TimeInterval) {
        guard let parentNode = parentNode else { return }
        //I think I'm gonna try keeping the analog stick, but if more than e.g. 0.5 forawrd, go forward all the way
        //and if more than a little bit left, go left all the way, etc.
        
        //update: Above did not work, circular makes no sense
        //now tried square, if that doesn't work will need to try buttons
        //could do buttons but with the dymanic centering of the stick
        //I've never seen that before, it might be the best of both worlds
        
        
        //I think ideally I also want more of an acceleration
        
        //I increasingly think it makes sense to do this by modifying velocity directly, rather than by imparting forces
        
        if analogInputVector.dy > 0 {
            let speed = GameplayConfiguration.Player.forwardSpeed * Float(analogInputVector.dy) * 1000.0
            let vector = parentNode.presentation.convertVector(SCNVector3(speed, 0, 0), to: scene.rootNode)
            parentNode.physicsBody?.applyForce(vector, asImpulse: false)
        } else if analogInputVector.dy < 0 {
            let speed = GameplayConfiguration.Player.backwardSpeed * Float(analogInputVector.dy) * 1000.0
            let vector = parentNode.presentation.convertVector(SCNVector3(speed, 0, 0), to: scene.rootNode)
            parentNode.physicsBody?.applyForce(vector, asImpulse: false)
        }
        
        
        //maybe this should rotate the forward velocity vector (like steering)
        if analogInputVector.dx != 0 {
            let rotationSpeed = GameplayConfiguration.Player.turningSpeed * Float(analogInputVector.dx) * 700.0
            parentNode.physicsBody?.applyTorque(SCNVector4(0, 1, 0, -rotationSpeed), asImpulse: false)
            
            //we might have to not rely on the angularDamning property depending on how much it messes with other rotation

            /* if I decide it's better to control the rotation directly:
             */
//             let currentVelocity = playerNode.physicsBody!.angularVelocity
//             let inputVelocity = GameplayConfiguration.Player.turningSpeed * Float(analogStickVector.dx) / 50.0
//            let intensity = (currentVelocity.w * currentVelocity.y) + inputVelocity
//
//            let new = SCNVector4(currentVelocity.x * currentVelocity.w,
//                                 currentVelocity.y * currentVelocity.w - inputVelocity,
//                                 currentVelocity.z * currentVelocity.w,
//                                 1)
//
//                playerNode.physicsBody?.angularVelocity = new

        }
    }
}
