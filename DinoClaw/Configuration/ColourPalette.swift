//Roar

import UIKit

extension UIColor {
    //TODO might be better to have set approved colours, and then match to the closest
    //guess we'll see how our colour palette ends up
    //(given tinysaurs can be any colour, that might be a losing battle...)
    var laserColor: UIColor {
        let components = hueSaturationBrightnessAlpha
        //todo I go back and forth on whose saturation value to use
        let laserComponents = GameplayConfiguration.Laser.colour.hueSaturationBrightnessAlpha
        return UIColor(hue: components.hue, saturation: components.saturation, brightness: laserComponents.brightness, alpha: laserComponents.alpha)
    }
}
