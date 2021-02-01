//Roar

import UIKit

extension UIColor {
    
    public convenience init(hueDegrees: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        self.init(hue: hueDegrees / 360.0, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    var hueSaturationBrightnessAlpha: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (hue: h, saturation: s, brightness: b, alpha: a)
    }
}
