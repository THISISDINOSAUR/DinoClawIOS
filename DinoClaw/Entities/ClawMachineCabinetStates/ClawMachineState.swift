import SceneKit
import GameplayKit

class ClawMachineState: GKState {
    
    let clawMachineNode: ClawMachineCabinetNode
    
    required init(clawMachineNode: ClawMachineCabinetNode) {
        self.clawMachineNode = clawMachineNode
        super.init()
    }
}
