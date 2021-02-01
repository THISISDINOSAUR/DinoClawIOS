//Roar

import SceneKit

//TODO add scale in and out
class LifespanComponent: Component {
    let lifespan: Double
    private var timeAlive = 0.0
    
    weak var parentNode: EntityNode?
    
    init(parentNode: EntityNode, lifespan: Double) {
        self.parentNode = parentNode
        self.lifespan = lifespan
    }
    
    func update(deltaTime: TimeInterval) {
        timeAlive += deltaTime
        if timeAlive > lifespan {
            parentNode?.removeFromParentNode()
        }
    }
}
