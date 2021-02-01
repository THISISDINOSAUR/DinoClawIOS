//Roar

import SceneKit

class DelayedActionComponent: Component {
    var timeToAction: TimeInterval?
    var action: (() -> Void)?
    
    func update(deltaTime: TimeInterval) {
        guard let timeToAction = timeToAction else { return }
        self.timeToAction = timeToAction - deltaTime
        if timeToAction <= 0 {
            self.timeToAction = nil
            action?()
        }
    }
}
