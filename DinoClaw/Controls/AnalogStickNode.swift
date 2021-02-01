//
//  Originally imported from PaintBrawling
//

import SpriteKit

protocol AnalogStickInputDelegate: class {
    func analogStickInput(input inputVector: CGVector)
}

class AnalogStickNode : SKSpriteNode {

    weak var delegate: AnalogStickInputDelegate?
    
    private let innerStick: SKSpriteNode
    private let outerStick: SKSpriteNode
    private var activeTouch: UITouch?
    private var stickOrigin = CGPoint.zero
    
    init(size: CGSize) {

        innerStick = SKSpriteNode.init(imageNamed: "analogStickInner.png")
        outerStick = SKSpriteNode.init(imageNamed: "analogStick.png")
        
        super.init(texture: nil, color: GameplayConfiguration.UI.AnalogStick.TouchableArea.color, size: size)
        
        self.isUserInteractionEnabled = true
        self.zPosition = 100
        self.addChild(innerStick)
        self.addChild(outerStick)
        innerStick.isHidden = true
        outerStick.isHidden = true

    }
    
    convenience init(bottomLeft: CGPoint, topRight: CGPoint) {
        self.init(size: CGSize(width: topRight.x - bottomLeft.x, height: topRight.y - bottomLeft.y))
        self.position = CGPoint(x: bottomLeft.x + floor((topRight.x - bottomLeft.x) / 2.0), y: bottomLeft.y + ceil((topRight.y - bottomLeft.y) / 2.0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        activeTouch = touches.first!
        
        let point = activeTouch!.location(in: self)
        innerStick.position = point
        outerStick.position = point
        stickOrigin = point
        innerStick.isHidden = false
        outerStick.isHidden = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        guard let touch = activeTouch else {
            return;
        }
        if !touches.contains(touch) {
            return;
        }
        let touchLocation = touch.location(in: self)
        let distanceFromStickOrigin = CGVector(dx: touchLocation.x - stickOrigin.x, dy: touchLocation.y - stickOrigin.y)
        
        let xLimit = outerStick.size.width / 2.0
        let yLimit = outerStick.size.height / 2.0
        let clampedPoint = CGPoint(
            x: min(max(distanceFromStickOrigin.dx, -xLimit), xLimit),
            y: min(max(distanceFromStickOrigin.dy, -yLimit), yLimit))
        let newPoint = CGPoint(
            x: stickOrigin.x + clampedPoint.x,
            y: stickOrigin.y + clampedPoint.y)

        innerStick.position = newPoint
        
        let normalisedControlVector = CGVector(dx: clampedPoint.x / xLimit, dy: clampedPoint.y / yLimit)
        delegate?.analogStickInput(input: normalisedControlVector)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        delegate?.analogStickInput(input: CGVector(dx: 0, dy: 0))
        
        innerStick.position = stickOrigin
        innerStick.isHidden = true
        outerStick.isHidden = true
        activeTouch = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)

        delegate?.analogStickInput(input: CGVector(dx: 0, dy: 0))
        
        innerStick.position = stickOrigin
        innerStick.isHidden = true
        outerStick.isHidden = true
        activeTouch = nil
    }
}
