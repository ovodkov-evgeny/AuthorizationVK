

import UIKit


class TransitionAnimatorShow: NSObject, UIViewControllerAnimatedTransitioning {
    
    var forPush = false
    private var duration: TimeInterval {
        get{ return forPush ? 1 : 1 }
    }
    
    
    convenience init(forPush: Bool) {
        self.init()
        self.forPush = forPush
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if forPush {
            getAnimateForPush(transitionContext: transitionContext)
        } else {
            getAnimateForPresentedView(transitionContext: transitionContext)
        }
        
    }
    
    
    private func getAnimateForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        destination.view.frame      = CGRect(x: source.view.frame.maxX, y: -source.view.frame.maxY, width: destination.view.frame.width, height: destination.view.frame.height)
        destination.view.transform  = CGAffineTransform(rotationAngle: 90)
        
        let destinationTargetFrame  = source.view.frame
        
        transitionContext.containerView.addSubview(destination.view)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            destination.view.frame  = destinationTargetFrame
            destination.view.transform = .identity
        }) { (isFinished) in
            source.removeFromParent()
            transitionContext.completeTransition(isFinished)
        }
    }
    
    private func getAnimateForPush(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        destination.view.frame.origin.y =  transitionContext.containerView.frame.maxY*2
        
        transitionContext.containerView.addSubview(destination.view)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [],  animations: {
            destination.view.frame.origin.y =  0
            
        }) { (isFinished) in
            
            transitionContext.completeTransition(isFinished)
        }
        
    }

}
