//
//  OtpVarificationViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 18/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit

class OtpVarificationViewController: UIViewController {
    
    @IBOutlet weak var firstNumberInOtpTextField:UITextField!
    @IBOutlet weak var secondNumberInOtpTextField:UITextField!
    @IBOutlet weak var thirdNumberInOtpTextField:UITextField!
    @IBOutlet weak var fourthNumberInOtpTextField:UITextField!
    @IBOutlet weak var fifthNumberInOtpTextField:UITextField!
    @IBOutlet weak var sixthNumberInOtpTextField:UITextField!
    @IBOutlet weak var continueButton:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }
    
    @IBAction func continueButtonPressed(_ sender:UIButton){
        
    }
    
    @IBAction func backButtonPressed(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func didNotGetOtpButtonPressed(_ sender: UIButton) {
    }
}

//All private function
extension OtpVarificationViewController{
    private func setup(){
        
        self.makeCardView(forButton: self.continueButton)
        
        self.firstNumberInOtpTextField.becomeFirstResponder()
        
        self.firstNumberInOtpTextField.addTarget(self, action: #selector(textFiledDidChanged(textField:)), for: .editingChanged)
        self.secondNumberInOtpTextField.addTarget(self, action: #selector(textFiledDidChanged(textField:)), for: .editingChanged)
        self.thirdNumberInOtpTextField.addTarget(self, action: #selector(textFiledDidChanged(textField:)), for: .editingChanged)
        self.fourthNumberInOtpTextField.addTarget(self, action: #selector(textFiledDidChanged(textField:)), for: .editingChanged)
        self.fifthNumberInOtpTextField.addTarget(self, action: #selector(textFiledDidChanged(textField:)), for: .editingChanged)
        self.sixthNumberInOtpTextField.addTarget(self, action: #selector(textFiledDidChanged(textField:)), for: .editingChanged)
    }
    
    @objc private func textFiledDidChanged(textField:UITextView){
        let text = textField.text
        
        if text?.utf16.count == 1{
            switch textField {
            case self.firstNumberInOtpTextField:
                self.secondNumberInOtpTextField.becomeFirstResponder()
                break
            case self.secondNumberInOtpTextField:
                self.thirdNumberInOtpTextField.becomeFirstResponder()
                break
            case self.thirdNumberInOtpTextField:
                self.fourthNumberInOtpTextField.becomeFirstResponder()
                break
            case self.fourthNumberInOtpTextField:
                self.fifthNumberInOtpTextField.becomeFirstResponder()
                break
            case self.fifthNumberInOtpTextField:
                self.sixthNumberInOtpTextField.becomeFirstResponder()
                break
            case self.sixthNumberInOtpTextField:
                self.sixthNumberInOtpTextField.resignFirstResponder()
                break
            default:
                break
            }
        }
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
