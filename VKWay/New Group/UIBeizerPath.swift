

import UIKit.UIBezierPath


extension UIBezierPath {
    convenience init(heartIn rect: CGRect) {
        self.init()
        
        let width   = rect.width
        let height  = rect.height 
        
        let bottomCenter = CGPoint(x: width * 0.5, y: height)
        let topCenter = CGPoint(x: width * 0.5, y: height * 0.25)
        let leftSideControl = CGPoint(x: -(width * 0.45), y: (height * 0.45))
        let leftTopControl = CGPoint(x: (width * 0.25), y: -(height * 0.2))
        let rightTopControl = CGPoint(x: width - leftTopControl.x, y: leftTopControl.y)
        let rightSideControl = CGPoint(x: width + (leftSideControl.x * -1), y: leftSideControl.y)
        
        self.move(to: bottomCenter)
        
        // Left Side Curve
        self.addCurve(to: topCenter,
                      controlPoint1: leftSideControl,
                      controlPoint2: leftTopControl)
        
        // Right Side Curve
        self.addCurve(to: bottomCenter,
                      controlPoint1: rightTopControl,
                      controlPoint2: rightSideControl)
        
        self.close()
    }
}

extension Int {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}
