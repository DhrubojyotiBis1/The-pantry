//
//  PopUpViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 13/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit

protocol popUpPopUpViewControllerDelegate {
    func popUpButtonTaped(withTag tag:Int)
}

class PopUpViewController: UIViewController {
    
    @IBOutlet weak var popView:UIView!
    @IBOutlet weak var popUpContenorView:UIView!
    var delegate:popUpPopUpViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }
    
    @IBAction func popUpButtonPressed(_ sender:UIButton){
       
        self.dismiss(animated: true) {
             self.delegate?.popUpButtonTaped(withTag: sender.tag)
        }
    }
    

    

}

extension PopUpViewController:popUpPopUpViewControllerDelegate{
    func popUpButtonTaped(withTag tag:Int){
        
    }
}

//ALL private functions
extension PopUpViewController{
    private func setup(){
        //setting the card view for the top view
               self.popView.layer.masksToBounds = false
               self.popView.layer.shadowColor = UIColor.gray.cgColor
               self.popView.layer.shadowOffset = CGSize(width: 0, height: 2)
               self.popView.layer.shadowOpacity = 0.4
        //adding tap gesture recocniser to the popup
        self.addTabGestureRecocniser()
    }
    
    //Function to add gesture recocniser to the popup
    private func addTabGestureRecocniser(){
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.popUpContenorView.addGestureRecognizer(tabGesture)
    }
    
    //function called when tap on the popUpcontenor view
    @objc private func onTap(){
        self.dismiss(animated: true, completion: nil)
    }
}
