//
//  OtpVarificationViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 18/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit

class OtpVarificationViewController: UIViewController {
    
    var phoneNumber = String()
    
    @IBOutlet weak var phoneNumberLable : UILabel!
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
        self.neworkingForOtpVarification()
    }
    
    @IBAction func backButtonPressed(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func didNotGetOtpButtonPressed(_ sender: UIButton) {
        self.networkingForResendingOtp()
    }
}



//MARK:- Networking stuff
extension OtpVarificationViewController{
    private func neworkingForOtpVarification() {
        let first = self.firstNumberInOtpTextField.text!
        let second = self.secondNumberInOtpTextField.text!
        let third = self.thirdNumberInOtpTextField.text!
        let fourth = self.fourthNumberInOtpTextField.text!
        let fifth = self.fifthNumberInOtpTextField.text!
        let sixth = self.sixthNumberInOtpTextField.text!
        
        let otp = first + second + third + fourth + fifth + sixth
        Networking().otpVarification(withOtp: otp, andPhoneNumber: self.phoneNumber) { (result, massage) in
            if(result){
                print("otp varification done")
                //check it the user is existing user or not
                //if not then send to register page
                //else send to home VC
            }else{
                if(massage == "otp_not_verified"){
                    //error deu to wrong otp entered
                    //show th error massage to user
                    print(1)
                }else if massage == "otp_expired"{
                    //error due to experied otp
                    //show th error massage to user
                    print(2)
                }else{
                    //netwok error
                    print("Network not present")
                }
            }
        }
        
    }
    
    private func networkingForResendingOtp(){
        Networking().resendOtp(forPhoneNumber: phoneNumber) { (result,token) in
            if(result){
                //otp resended done
                print("otp resended done")
            }else{
                if(token == 2){
                    //wrong mobile number
                    //show the error to the user
                }else{
                    //network probem
                    print("network problem")
                }
            }
        }
    }
}

//All private function
extension OtpVarificationViewController{
    private func setup(){
        self.phoneNumberLable.text = self.phoneNumber
        
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