//
//  lottieAnimation.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 03/02/20.
//  Copyright © 2020 coded. All rights reserved.
//

import Foundation
import Lottie

class animation{
    let animationView = AnimationView()
    let superView:UIView!
    var backgrountAnimationView:UIView!
    
    init(animationView:UIView) {
        self.superView = animationView
    }
    
    public func play(){
        
        
        backgrountAnimationView = UIView(frame: CGRect(x: 0, y: 0, width: self.superView.bounds.width, height: self.superView.bounds.height))
        backgrountAnimationView.backgroundColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha:0.3)
        backgrountAnimationView.isOpaque = false
        self.superView.addSubview(backgrountAnimationView)
        backgrountAnimationView.translatesAutoresizingMaskIntoConstraints = false
        backgrountAnimationView.leadingAnchor.constraint(equalToSystemSpacingAfter: self.superView.leadingAnchor, multiplier: 0).isActive = true
        backgrountAnimationView.topAnchor.constraint(equalToSystemSpacingBelow: self.superView.topAnchor, multiplier: 0).isActive = true
        backgrountAnimationView.bottomAnchor.constraint(equalToSystemSpacingBelow: self.superView.bottomAnchor, multiplier: 0).isActive = true
        backgrountAnimationView.trailingAnchor.constraint(equalToSystemSpacingAfter: self.superView.trailingAnchor, multiplier: 0).isActive = true
        
        
        let animation = Animation.named("4762-food-carousel")
        animationView.animation = animation
        backgrountAnimationView.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        let size = backgrountAnimationView.bounds.width/3
        animationView.heightAnchor.constraint(equalToConstant: size).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: size).isActive = true
        animationView.centerYAnchor.constraint(equalToSystemSpacingBelow: backgrountAnimationView.centerYAnchor, multiplier: 0).isActive = true
        animationView.centerXAnchor.constraint(equalToSystemSpacingAfter: backgrountAnimationView.centerXAnchor, multiplier: 0).isActive = true
        animationView.loopMode = .loop
        self.animationView.isHidden = false
        animationView.play()
    }
    
    public func stop(){
        self.animationView.stop()
        self.backgrountAnimationView.isHidden = true
        self.animationView.isHidden = true
    }
    
}
