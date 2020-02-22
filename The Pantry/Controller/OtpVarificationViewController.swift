//
//  OtpVarificationViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 18/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit
import Toast_Swift
class OtpVarificationViewController: UIViewController {
    
    var phoneNumber = String()
    var token = String()
    var isVarifyingForForgetPassword = false
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var phoneNumberLable : UILabel!
    @IBOutlet weak var firstNumberInOtpTextField:UITextField!
    @IBOutlet weak var secondNumberInOtpTextField:UITextField!
    @IBOutlet weak var thirdNumberInOtpTextField:UITextField!
    @IBOutlet weak var fourthNumberInOtpTextField:UITextField!
    @IBOutlet weak var continueButton:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }
    
    @IBAction func continueButtonPressed(_ sender:UIButton){
        if isVarifyingForForgetPassword{
            self.phoneNumber = "91-" + self.phoneNumber
        }
        self.neworkingForOtpVarification()
    }
    
    @IBAction func backButtonPressed(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func didNotGetOtpButtonPressed(_ sender: UIButton) {
        if isVarifyingForForgetPassword{
            self.dismiss(animated: true, completion: nil)
        }else{
            self.networkingForResendingOtp()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.registrationVCId{
            let destination = segue.destination as! RegisterViewController
            destination.mobileNumber = self.phoneNumber
        }else if segue.identifier == segueId.ForgotPasswordChangePasswordVCId{
            let destinaton = segue.destination as! NewPasswordViewController
            destinaton.token = self.token
        }
    }
}



//MARK:- Networking stuff
extension OtpVarificationViewController{
    private func neworkingForOtpVarification() {
        let first = self.firstNumberInOtpTextField.text!
        let second = self.secondNumberInOtpTextField.text!
        let third = self.thirdNumberInOtpTextField.text!
        let fourth = self.fourthNumberInOtpTextField.text!
        
        let otp = first + second + third + fourth
        if isVarifyingForForgetPassword{
            
            Networking().varifyParrowordForForgetpassword(withOtp: otp, andToken: token){ (result, massage) in
                if(result){
                    print("otp varification done")
                    //check it the user is existing user or not
                    //if not then send to register page
                    //else send to home VC
                    self.token = massage!
                    self.performSegue(withIdentifier: segueId.ForgotPasswordChangePasswordVCId, sender: nil)
                }else{
                    if(massage == "otp_not_verified"){
                        //error deu to wrong otp entered
                        //show th error massage to user
                        self.view.makeToast("otp_not_verified", duration: 3, position: .bottom, completion: nil)
                    }else if massage == "otp_expired"{
                        //error due to experied otp
                        //show th error massage to user
                        self.view.makeToast("otp_not_verified", duration: 3, position: .bottom, completion: nil)
                    }else{
                        //netwok error
                        print("Network not present")
                    }
                }
            }

            
        }else{
            Networking().otpVarification(withOtp: otp, andPhoneNumber: self.phoneNumber) { (result, massage) in
                if(result){
                    print("otp varification done")
                    //check it the user is existing user or not
                    //if not then send to register page
                    //else send to home VC
                    self.performSegue(withIdentifier: segueId.registrationVCId, sender: nil)
                }else{
                    if(massage == "otp_not_verified"){
                        //error deu to wrong otp entered
                        //show th error massage to user
                        self.view.makeToast("otp_not_verified", duration: 3, position: .bottom, completion: nil)
                    }else if massage == "otp_expired"{
                        //error due to experied otp
                        //show th error massage to user
                        self.view.makeToast("otp_not_verified", duration: 3, position: .bottom, completion: nil)
                    }else{
                        //netwok error
                        print("Network not present")
                    }
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func onTap(){
        self.firstNumberInOtpTextField.endEditing(true)
        self.secondNumberInOtpTextField.endEditing(true)
        self.thirdNumberInOtpTextField.endEditing(true)
        self.fourthNumberInOtpTextField.endEditing(true)
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
                self.fourthNumberInOtpTextField.resignFirstResponder()
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
