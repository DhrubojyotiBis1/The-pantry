//
//  EnterOtpViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 18/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit

class EnterMoblieNumberController: UIViewController {
    
    @IBOutlet weak var nextButton:UIButton!
    @IBOutlet weak var mobileNumbertextField:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }
    
    @IBAction func nextButtonPressed(_ sender:UIButton){
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //when the view is disappering the mobline number is being removed
        self.mobileNumbertextField.text = ""
    }

}




//All private function
extension EnterMoblieNumberController{
    
    private func setup(){
        self.makeCardView(forButton: self.nextButton)
    }
    
    private func makeCardView(forButton button:UIButton){
        //setting the card view for the top view
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4.5)
        button.layer.shadowOpacity = 0.4
        button.layer.cornerRadius = 10
    }
}
