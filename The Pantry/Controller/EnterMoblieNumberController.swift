//
//  EnterOtpViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 18/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit
import SVProgressHUD
import Toast_Swift

class EnterMoblieNumberController: UIViewController {
    
    private let countryCode = "91"
    private var phoneNumber = String()
    
    @IBOutlet weak var nextButton:UIButton!
    @IBOutlet weak var mobileNumbertextField:UITextField!
    @IBOutlet weak var contentView:UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }
    
    @IBAction func nextButtonPressed(_ sender:UIButton){
        if(self.mobileNumbertextField.text?.count == 10){
            //10 digit entered
            self.neworking()
            self.performSegue(withIdentifier: segueId.otpvaruficationVCId, sender: nil)
        }else{
            //10 digit not entered show the error to the user"
            if(mobileNumbertextField.text?.count == 0){
                self.view.makeToast(massage.enterMobileNumber, duration: massage.duration, position: .center)
            }else{
                self.view.makeToast(massage.moblieNumberCountErrorMassage, duration: massage.duration, position: .center)
            }
        }
    }
    
    @IBAction func alreadyHaveAnAccountButtonPressed(_ sender:UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //when the view is disappering the mobline number is being removed
        self.mobileNumbertextField.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.otpvaruficationVCId{
            let destination = segue.destination as! OtpVarificationViewController
            print(phoneNumber)
            destination.phoneNumber = self.phoneNumber
        }
    }

}

//MARK:- Networking stuff
extension EnterMoblieNumberController{
    private func neworking() {
        self.phoneNumber = self.countryCode + self.mobileNumbertextField.text!
        Networking().getOtp(withPhoneNumber: phoneNumber) { (result,type) in
            if(result){
                
            }else{
                if(type == "error"){
                    //error due to invaild mobile number
                    //show the massage to the user

                }else{
                    //internet not available
                    //show the error to the user
                    print(type)
                }
            }
        }
    }
}


//All private function
extension EnterMoblieNumberController{
    
    private func setup(){
        self.makeCardView(forButton: self.nextButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func onTap(){
        self.mobileNumbertextField.endEditing(true)
        SVProgressHUD.dismiss()
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
