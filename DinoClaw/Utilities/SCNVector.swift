//Roar

import SceneKit

func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
}

func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
}

func *(lhs:SCNVector3, rhs: Float) -> SCNVector3 {
    return SCNVector3(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs)
}

extension SCNVector3 {
    var length: Float {
        sqrt(x*x + y*y + z*z)
    }
    
    var groundLength: Float {
        sqrt(x*x + z*z)
    }
    
    var normalised: Self {
        let len = length
        if len == 0 {
            return self
        }
        return SCNVector3(x / len, y / len, z / len)
    }
}
