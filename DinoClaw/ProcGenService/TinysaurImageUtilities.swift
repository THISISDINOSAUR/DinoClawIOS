//Roar

import UIKit

extension UIImage {
    
    func findMajorColor(colourOrdinality: Int = 0) -> UIColor? {
        return processImage() { pixelBuffer in
            let width = Int(size.width)
            let height = Int(size.height)
            var colours = [RGBA32: Int]()
            for row in 0..<height {
                for column in 0..<width {
                    let offset = row * Int(size.width) + column
                    let colour = pixelBuffer[offset]
                    if colour.alphaComponent > 0 && colour != .black {
                        let count = colours[pixelBuffer[offset]] ?? 0
                        colours[pixelBuffer[offset]] = count + 1
                    }
                }
            }
            let sorted = colours.sorted { $0.1 < $1.1 }
            guard  colourOrdinality < sorted.count else {
                return nil
            }
            return sorted[sorted.count - 1 - colourOrdinality].key.uiColor
        }
    }
    
    func findFrontFoot() -> Int? {
        return processImage() { pixelBuffer in
            let width = Int(size.width)
            for column in 1...width {
                //front is last
                //so lets go backwards
                let columnInverted = width - column
                let offset = (Int(size.height) - 1) * Int(size.width) + columnInverted
                if pixelBuffer[offset] == .black {
                    return columnInverted
                }
            }
            return nil
        }
    }
    
    func processImage<T>(processClosure: (UnsafeMutablePointer<RGBA32>) -> T?) -> T? {
        guard let inputCGImage = cgImage else {
            assertionFailure()
            return nil
        }
        let width = inputCGImage.width
        let height = inputCGImage.height

        guard let context = CGContext(
                data: nil,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: 4 * width,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: RGBA32.bitmapInfo) else {
            assertionFailure()
            return nil
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let buffer = context.data else {
            assertionFailure()
            return nil
        }

        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)

        return processClosure(pixelBuffer)
    }
}

struct RGBA32: Equatable, Hashable {
    private var color: UInt32

    var redComponent: UInt8 {
        return UInt8((color >> 24) & 255)
    }

    var greenComponent: UInt8 {
        return UInt8((color >> 16) & 255)
    }

    var blueComponent: UInt8 {
        return UInt8((color >> 8) & 255)
    }

    var alphaComponent: UInt8 {
        return UInt8((color >> 0) & 255)
    }
    
    var uiColor: UIColor {
        let div: CGFloat = 255
        return UIColor(red: CGFloat(redComponent) / div, green: CGFloat(greenComponent) / div, blue: CGFloat(blueComponent) / div, alpha: CGFloat(alphaComponent) / div)
    }

    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        let red   = UInt32(red)
        let green = UInt32(green)
        let blue  = UInt32(blue)
        let alpha = UInt32(alpha)
        color = (red << 24) | (green << 16) | (blue << 8) | (alpha << 0)
    }

    static let red     = RGBA32(red: 255, green: 0,   blue: 0,   alpha: 255)
    static let green   = RGBA32(red: 0,   green: 255, blue: 0,   alpha: 255)
    static let blue    = RGBA32(red: 0,   green: 0,   blue: 255, alpha: 255)
    static let white   = RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
    static let black   = RGBA32(red: 0,   green: 0,   blue: 0,   alpha: 255)

    static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue

    static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
        return lhs.color == rhs.color
    }
}
