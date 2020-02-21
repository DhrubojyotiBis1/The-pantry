//
//  ForgotPassowordViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 21/02/20.
//  Copyright © 2020 coded. All rights reserved.
//

import UIKit

class ForgotPassowordViewController: UIViewController {
    
    private let countryCode = "91"
    private var phoneNumber = String()
    private var token = String()
    var animationController:animation! = nil
    
    @IBOutlet weak var mobileNumberTextFiled:UITextField!
    @IBOutlet weak var navigationView:UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUp()
    }
    
    @IBAction func getOtpButtonPressed(_ sender:UIButton){
        if(self.mobileNumberTextFiled.text?.count == 10){
            //10 digit entered
            animationController.play()
            self.neworking()
        }else{
            //10 digit not entered show the error to the user"
            if(mobileNumberTextFiled.text?.count == 0){
                self.view.makeToast(massage.enterMobileNumber, duration: massage.duration, position: .center)
            }else{
                self.view.makeToast(massage.moblieNumberCountErrorMassage, duration: massage.duration, position: .center)
            }
        }
    }
    
    @IBAction func backBUttonPressed(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.otpvaruficationVCId{
            let destination = segue.destination as! OtpVarificationViewController
            destination.isVarifyingForForgetPassword = true
            destination.phoneNumber = self.phoneNumber
            destination.token = self.token
        }
    }

}

extension ForgotPassowordViewController{
    
    private func setUp(){
        self.animationController = animation(animationView: self.view)
        
        self.makeCardView(fromViews: self.navigationView, isViewNavigationBar: true)
    }
    
    private func makeCardView(fromViews view:UIView,isViewNavigationBar :Bool){
        //makeing the card view for the view
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.4
        if(isViewNavigationBar){
            view.layer.shadowOffset = CGSize(width: 0, height: 4.5)
        }else{
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }
}

extension ForgotPassowordViewController{
    private func neworking() {
        self.phoneNumber = self.mobileNumberTextFiled.text!
        Networking().getForgetPassordOTP(toPhoneNumber: self.phoneNumber) { (result, token) in
            self.animationController.stop()
            if result{
                self.token = token
                self.performSegue(withIdentifier: segueId.otpvaruficationVCId, sender: nil)
            }else{
                print(token)
                //show error to the user
                self.view.makeToast(token, duration: massage.duration, position: .center)
                
            }
        }
    }
}
