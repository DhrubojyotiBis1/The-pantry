//
//  testViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 17/01/20.
//  Copyright © 2020 coded. All rights reserved.
//

import UIKit

protocol MenuViewControllerProtocol {
    func didMenuDismis(withOption option:Int?)
    func selectedMenu(option:Int?)
}

class MenuViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var contentView:UIView!
    @IBOutlet weak var scrollableView:UIView!
    @IBOutlet  var menuOptionButtons:[UIButton]!
    @IBOutlet  var menuLableViews:[UIView]!
    
    var delegate:MenuViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
        
    }
    
    @IBAction func backButtonPressed(_ sender:UIButton){
        self.dismisView(withOption: nil)
    }
    
    @IBAction func menuOptionSelected(_ sender:UIButton){
        self.dismisView(withOption: sender.tag)
    }

}

extension MenuViewController{
    private func setup(){
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        self.topView.layer.masksToBounds = false
        self.topView.layer.shadowColor = UIColor.gray.cgColor
        self.topView.layer.shadowOffset = CGSize(width: 0, height: 4.5)
        self.topView.layer.shadowOpacity = 0.4
        
        //changing the width of the menu view
        width.constant = self.view.bounds.width * 0.6
        
        //adding tap gusture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.contentView.addGestureRecognizer(tapGesture)
        
        for i in 0..<self.menuLableViews.count{
            
            var tapGesture:UIGestureRecognizer!
            
            if i == 0{
                 tapGesture = UITapGestureRecognizer(target: self, action: #selector(onProfileViewTap))
            }else if i == 1{
                 tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTransactionViewTap))
                
            }else if i == 2{
                
                 tapGesture = UITapGestureRecognizer(target: self, action: #selector(onShareTap))
                
            }else if i == 3{
                
                 tapGesture = UITapGestureRecognizer(target: self, action: #selector(onPrivacyViewTap))
                
            }else if i == 4{
                
                 tapGesture = UITapGestureRecognizer(target: self, action: #selector(onFAQViewTap))
                
            }else if i == 5{
                
                 tapGesture = UITapGestureRecognizer(target: self, action: #selector(onAboutUsViewTap))
                
            }else if i == 6{
                tapGesture = UITapGestureRecognizer(target: self, action: #selector(contactUs))
            }else if i == 7{
                tapGesture = UITapGestureRecognizer(target: self, action: #selector(logOut))
            }
            self.menuLableViews[i].addGestureRecognizer(tapGesture)
            
        }
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {


            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                self.dismisView(withOption: nil)
                default:
                    break
            }
        }
    }
    
    @objc private func onProfileViewTap(){
        self.dismisView(withOption: 0)
    }
    
    @objc private func onTransactionViewTap(){
        self.dismisView(withOption: 1)
    }
    
    @objc private func onShareTap(){
        self.dismisView(withOption: 2)
    }
    
    @objc private func onPrivacyViewTap(){
        self.dismisView(withOption: 3)
    }
    
    @objc private func onFAQViewTap(){
        self.dismisView(withOption: 4)
    }
    
    @objc private func onAboutUsViewTap(){
       self.dismisView(withOption: 5)
    }
    
    @objc private func onTap(){
        self.dismisView(withOption: nil)
    }
    
    @objc private func contactUs(){
        self.dismisView(withOption: 6)
    }
    
    @objc private func logOut(){
        self.dismisView(withOption: 7)
    }
    
    private func dismisView(withOption option:Int?){
        self.delegate?.didMenuDismis(withOption: option)
        if option == nil {
            dismiss(animated: true) {
                print("dismiss \(option as Any)")
            }
        }else{
            dismiss(animated: true) {
                self.delegate?.selectedMenu(option: option)
                 print("dismiss \(option as Any)")
            }
        }
    }
    
}
