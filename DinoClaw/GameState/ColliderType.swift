
import SpriteKit
import GameplayKit

struct ColliderType: OptionSet, Hashable {
    
    static var requestedContactNotifications = [ColliderType: [ColliderType]]()
    
    static var definedCollisions = [ColliderType: [ColliderType]]()
    
    let rawValue: Int
    
    // Mark: Options
    
    static var Ground: ColliderType { return self.init(rawValue: 1 << 1) }
    static var Dinosaur: ColliderType { return self.init(rawValue: 1 << 2) }
    static var City: ColliderType { return self.init(rawValue: 1 << 4) }
    static var Laser: ColliderType { return self.init(rawValue: 1 << 8) }
    
    // Mark: Hashable
    
    var hashValue: Int {
        return Int(rawValue)
    }
    
    var categoryMask: Int {
        return rawValue
    }
    
    var collisionMask: Int {
        let mask = ColliderType.definedCollisions[self]?.reduce(ColliderType()) { initial, colliderType in
            return initial.union(colliderType)
        }
        return mask?.rawValue ?? 0 //won't collide with anything if no mask
    }
    
    var contactMask: Int {
        let mask = ColliderType.requestedContactNotifications[self]?.reduce(ColliderType()) { initial, colliderType in
            return initial.union(colliderType)
        }
        
        return mask?.rawValue ?? 0
    }
    
    func notifyOnContactWithColliderType(_ colliderType: ColliderType) -> Bool {
        if let requestedContacts = ColliderType.requestedContactNotifications[self] {
            return requestedContacts.contains(colliderType)
        }
        return false
    }
}
