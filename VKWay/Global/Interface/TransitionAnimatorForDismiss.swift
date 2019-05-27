//
//  ViewAppearDisappearAnimation.swift
//  VKWay
//
//  Created by Cayenne on 30/03/2019.
//  Copyright © 2019 Cayenne. All rights reserved.
//

import UIKit

class TransitionAnimatorForDismiss: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    var forPop = false
    private var duration: TimeInterval {
        get{ return forPop ? 0.5 : 1 }
    }
    
    
    convenience init(forPop: Bool) {
        self.init()
        self.forPop = forPop
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if forPop {
            getAnimateForPush(transitionContext: transitionContext)
        } else {
            getAnimateForDismissed(transitionContext: transitionContext)
        }
        
    }

    
    //почему-то при закрытии картинка и главный view уезжают не как одно целое
    func getAnimateForDismissed(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
    
        
        destination.view.frame  = transitionContext.containerView.frame
        destination.view.layer.zPosition = 0
        source.view.layer.zPosition = 1
        
        
        transitionContext.containerView.addSubview(destination.view)
        
        UIView.animate(withDuration: duration,  animations: {
            
            source.view.frame      = CGRect(x: transitionContext.containerView.frame.maxX, y: -transitionContext.containerView.frame.maxY, width: transitionContext.containerView.frame.width, height: transitionContext.containerView.frame.height)
            source.view.transform  = CGAffineTransform(rotationAngle: 90)
            
        }) { (isFinished) in
            source.removeFromParent()
            transitionContext.completeTransition(isFinished)
        }
        
    }
    
    func getAnimateForPush(transitionContext: UIViewControllerContextTransitioning) {
     
        guard let source = transitionContext.viewController(forKey: .from), let destination = transitionContext.viewController(forKey: .to) else { return }
        
        source.view.layer.zPosition = 1
        transitionContext.containerView.addSubview(destination.view)
        
        
        UIView.animate(withDuration: duration, animations: {
            source.view.frame.origin.y = transitionContext.containerView.frame.maxY*2
        }) { (isFinished) in
            if isFinished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            } else if transitionContext.transitionWasCancelled {
                
            }
            transitionContext.completeTransition(isFinished && !transitionContext.transitionWasCancelled)
        }

        
    }

}
