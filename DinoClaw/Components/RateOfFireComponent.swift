//Roar

import SceneKit

class RateOfFireComponent: Component {
    var timeToLoad: TimeInterval
    var readyToFire: Bool {
        return timeUntilReady <= 0
    }
    
    private var timeUntilReady: TimeInterval = 0
    private var reloading = false
    
    init(timeToLoad: TimeInterval) {
        self.timeToLoad = timeToLoad
    }
    
    func update(deltaTime: TimeInterval) {
        guard reloading, timeUntilReady > 0 else { return }
        timeUntilReady -= deltaTime
    }
    
    func startReload() {
        reloading = true
    }
    
    func fire() {
        reloading = false
        timeUntilReady = timeToLoad
    }
}
