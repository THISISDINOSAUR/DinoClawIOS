//Roar

import SceneKit

protocol Component {
    func update(deltaTime: TimeInterval)
}

class EntityNode: SCNNode {
    var components = [Component]()
    
    func update(deltaTime: TimeInterval) {
        for component in components {
            component.update(deltaTime: deltaTime)
        }
    }
}

extension SCNNode {
    func traverse() -> [SCNNode] {
        var nodes = [self]
        for child in childNodes {
            nodes += child.traverse()
        }
        return nodes
    }
}
