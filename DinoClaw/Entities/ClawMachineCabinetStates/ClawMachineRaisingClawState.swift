import SceneKit
import GameplayKit

class ClawMachineRaisingClawState: GKState {
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is ClawMachineLoweringClawState.Type
    }
}
