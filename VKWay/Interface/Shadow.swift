

import UIKit

class Shadow {
    
    static func addShadow(object: UIView, radius:CGFloat) {
        
        let shadowLayer = UIView(frame: object.frame)
        shadowLayer.backgroundColor = UIColor.white.withAlphaComponent(0)
        shadowLayer.layer.shadowColor = UIColor.black.cgColor
        shadowLayer.layer.shadowPath = UIBezierPath(roundedRect: object.bounds, cornerRadius: object.layer.cornerRadius).cgPath
        shadowLayer.layer.shadowOffset = CGSize.zero//CGSize(width: 1.0, height: 1.0)
        shadowLayer.layer.shadowOpacity = 0.5
        shadowLayer.layer.shadowRadius = 8
        shadowLayer.layer.masksToBounds = true
        shadowLayer.clipsToBounds = false
        
        object.superview?.addSubview(shadowLayer)
        object.superview?.bringSubviewToFront(object.self)
        
    }
    
}
