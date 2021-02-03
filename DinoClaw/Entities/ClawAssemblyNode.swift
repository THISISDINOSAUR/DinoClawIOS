//Roar

import SceneKit

class ClawAssemblyNode: EntityNode {
    
    lazy var clawNode = ClawNode()
    
    override init() {
        super.init()
        
        addChildNode(clawNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
