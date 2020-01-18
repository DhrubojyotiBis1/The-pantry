//
//  slideMenuAnimation.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 17/01/20.
//  Copyright © 2020 coded. All rights reserved.
//

import UIKit

class slideMenuAnimation: NSObject ,UIViewControllerAnimatedTransitioning{
    
    var isPresenting = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else{return}
        
        let contenerView = transitionContext.containerView
        
        let finalWidth = toViewController.view.bounds.width 
        let finalHight = toViewController.view.bounds.height
        
        if isPresenting {
            //add menu viewController to contener
            contenerView.addSubview(toViewController.view)
            
            //init fram off the screen
            toViewController.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHight)
            
        }
        
        //animate on to screen
        let transform = {
            
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
            
        }
        
        //animate back to the main screen
        
        let identity = {
            fromViewController.view.transform = .identity
        }
        
        
        //animation for transection
        let duration = transitionDuration(using: transitionContext)
        let isCanceled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? transform() : identity()
        }) { (_) in
            transitionContext.completeTransition(!isCanceled)
        }
    }
    

}
