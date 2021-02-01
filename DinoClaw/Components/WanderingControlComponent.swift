//Roar

import SceneKit

//pick a direction or point to walk in?
//then walk until reach end or we randomly decided to change direction

//also not moving lots of the time

class WanderingControlComponent: Component {
    
    //TODO falling over state
    enum WanderingState {
        case standing
        case moving
    }
    
    weak var parentNode: EntityNode!
    let centerPoint: SCNVector3
    let radius: Float
    
    let minTimeInState: TimeInterval
    let maxTimeInState: TimeInterval
    
    private var timeInState: TimeInterval = 0
    private var timeInStateLimit: TimeInterval
    
    var wanderingState: WanderingState = .moving {
        didSet {
            if oldValue != wanderingState {
                timeInState = 0
                timeInStateLimit = Double.random(in: minTimeInState...maxTimeInState)
            }
            switch wanderingState {
            case .standing:
                print("Don't need to do anything?")
            case .moving:
                let point = SCNVector3.randomPointOnGroundCircle(radius: radius, center: centerPoint)
                //TODO how we gonna rotate to face the right way?
            }
        }
    }
    
    init(parentNode: EntityNode, centerPoint: SCNVector3, radius: Float, minTimeInState: TimeInterval = 0.5, maxTimeInState: TimeInterval = 5.0) {
        self.parentNode = parentNode
        self.centerPoint = centerPoint
        self.radius = radius
        self.minTimeInState = minTimeInState
        self.maxTimeInState = maxTimeInState
        timeInStateLimit = Double.random(in: minTimeInState...maxTimeInState)
    }
    
    func update(deltaTime: TimeInterval) {
        timeInState += deltaTime
        changeStateIfNeeded(deltaTime: deltaTime)
        //TODO
        //wandering behaviour
    }
    
    private func changeStateIfNeeded(deltaTime: TimeInterval) {
        switch wanderingState {
        case .standing:
            if timeInState >= timeInStateLimit {
                wanderingState = .moving
            }
        case .moving:
            if timeInState >= timeInStateLimit {
                //TODO we're gonna have to be careful here when picking a new direction to avoid immediatly going out of the radius again and stopping
                //if I think maybe we need a min time to be wandering?, like 0.2 seconds is too little
                //or maybe we just pick a vector that's close to the center
                //hmm we could do that easily with something like
                //new direction = center +/- random(half radius)
                wanderingState = .standing
            } else {
                let point = parentNode.position - centerPoint
                let distance = point.length
                if distance >= radius {
                    wanderingState = .standing
                }
            }
        }
    }
}
