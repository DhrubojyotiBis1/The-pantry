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
        
        
        self.topView.layer.masksToBounds = false
        self.topView.layer.shadowColor = UIColor.gray.cgColor
        self.topView.layer.shadowOffset = CGSize(width: 0, height: 4.5)
        self.topView.layer.shadowOpacity = 0.4
        
        //changing the width of the menu view
        width.constant = self.view.bounds.width * 0.6
        
        //adding tap gusture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.contentView.addGestureRecognizer(tapGesture)
        
        let tapGestureForScrollableView = UITapGestureRecognizer(target: self, action: #selector(onScrollViewTap))
        self.scrollableView.addGestureRecognizer(tapGestureForScrollableView)
    }
    
    @objc private func onScrollViewTap(){
        self.dismisView(withOption: nil)
    }
    
    @objc private func onTap(){
        self.dismisView(withOption: nil)
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
