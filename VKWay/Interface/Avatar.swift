

import UIKit

@IBDesignable class Avatar: UIImageView {

    @IBInspectable var radius: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowRadius: Int = 0
    
    override func didMoveToWindow() {
        
        layer.cornerRadius  = frame.height/2
        layer.masksToBounds = true
        layer.shouldRasterize   = true
    
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

}

    



