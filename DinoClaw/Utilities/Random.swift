import SceneKit

class Random {
    
    static func randAround<Decimal: FloatingPoint>(_ center: Decimal, plusOrMinus: Decimal) -> Decimal {
        return center - plusOrMinus +
            (Decimal.rand() * plusOrMinus * 2)
    }
}

extension FloatingPoint {
    static func rand() -> Self {
        return Self.init(arc4random()) / Self.init(UINT32_MAX)
    }
}

extension SCNVector3 {
    
    static func pointOnGroundCircle(radius: Float, degrees: Float, center: Self) -> Self {
        let theta = degrees.degreesToRadians
        let x = radius * cos(theta)
        let z = radius * sin(theta)
        return SCNVector3(center.x + x, center.y, center.z + z)
    }
    
    static func randomPointOnGroundCircle(radius: Float, center: Self) -> Self {
        return pointOnGroundCircle(radius: radius, degrees: Float.random(in: 0..<360), center: center)
    }
    
    //TODO can use this to generate points in a doughnut
    //I was thinking of using that idea for island generation
    //probably want to be able to specify degrees for that
    static func randomPointWithinGroundCircle(radius: Float, center: Self) -> Self {
        let r = radius * sqrt(Float.rand())
        let theta = Float.random(in: 0..<360).degreesToRadians
        let x = r * cos(theta)
        let z = r * sin(theta)
        return SCNVector3(center.x + x, center.y, center.z + z)
    }
}
