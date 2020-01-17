//
//  testViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 17/01/20.
//  Copyright © 2020 coded. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var contentView:UIView!
    @IBOutlet weak var scrollableView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
        
    }
    

}

extension MenuViewController{
    private func setup(){
        
        //changing the width of the menu view
        width.constant = self.view.bounds.width * 0.8
        
        //adding tap gusture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.contentView.addGestureRecognizer(tapGesture)
        
        let tapGestureForScrollableView = UITapGestureRecognizer(target: self, action: #selector(onScrollViewTap))
        self.scrollableView.addGestureRecognizer(tapGestureForScrollableView)
    }
    
    @objc private func onScrollViewTap(){
        dismiss(animated: true) {
            print("dismiss \(1)")
        }
    }
    
    @objc private func onTap(){
        dismiss(animated: true) {
            print("dismiss \(-1)")
        }
    }
    
}
