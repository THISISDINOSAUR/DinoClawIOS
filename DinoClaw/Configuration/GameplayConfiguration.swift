//Roar

import Foundation
import SpriteKit
import SceneKit

struct GameplayConfiguration {
    struct Debug {
        static let isDrawingOn = true
    }
    
    struct Game {
        static let maximumUpdateDeltaTime = 0.25
    }
    
    struct World {
        struct Ground {
            static let color = UIColor(hueDegrees: 147, saturation: 0.85, brightness: 0.89, alpha: 1.0)
        }
        
        struct Lights {
            struct Directional {
                static let rotation = SCNVector3(x: -.pi/7, y: 0, z: 0)
                static let intensity: CGFloat = 2300
                static let color = UIColor(hueDegrees: 42, saturation: 0.25, brightness: 1.0, alpha: 1.0)
            }
            
            struct Ambient {
                static let color = UIColor(hueDegrees: 50, saturation: 0.67, brightness: 1.0, alpha: 1.0)
            }
        }
    }
    
    struct Tree {
        static let scale: CGFloat = 0.2
    }
    
    struct Cloud {
        static let scale: CGFloat = 5
        static let height: Float = 20
        static let alpha: CGFloat = 0.6
    }
    
    struct Tinysaur {
        static let startingHeightFromGround: Float = 0.1
        static let physicsBodyThicknessAsProportionOfHeight: CGFloat = 0.2
        static let centerOfMassHeightAsProportionOfHeight: CGFloat = 0.1
        
        static let ceratopsScale: CGFloat = 0.08
        static let pachycephalosaurScale: CGFloat = 0.06
        static let ankylosaurScale: CGFloat = 0.08
        static let stegosaurScale: CGFloat = 0.08
        static let iguanodonScale: CGFloat = 0.08
        static let sauropodScale: CGFloat = 0.2
        static let largeTheropodScale: CGFloat = 0.13
        static let smallTheropodScale: CGFloat = 0.035
        
        static let scaleVariance: Float = 0.3
    }
    
    struct Laser {
        static let radius: CGFloat = 0.12
        static let length: CGFloat = 1.9
        static let colour = UIColor(hueDegrees: 342, saturation: 0.72, brightness: 1.0, alpha: 1.0)
    }
    
    struct Player {
        static let scale: CGFloat = 0.2
        static let forwardSpeed: Float = 1.0
        static let backwardSpeed: Float = 1.0
        static let turningSpeed: Float = 1.0
    }
    
    struct City {
        static let thickness: CGFloat = 0.4
    }
        
    struct Camera {
        static let startingHeight: Float = 5.0
        static let startingDistanceFromPlayer: Float = 20.0
        
        static let rotationSpeed: Float = 1.0
        static let lowestAllowedAngle = 10
        static let highestAllowedAngle = -70
        
        static let numberOfFingersToPan = 1
        static let minimumDistanceFromPlayer: Float = 5
        static let maximumDistanceFromPlayer: Float = 30
        static let zoomSpeed: Float = 1.0
        
    }
    
    struct UI {
        struct AnalogStick {
            struct TouchableArea {
                static let proportionOfScreenWidth: Float = 0.4
                static let proportionOfScreenHeight: Float = 0.4
                static let color = UIColor(hueDegrees: 147, saturation: 0.0, brightness: 0.5, alpha: 0.4)
            }
        }
    }
}
