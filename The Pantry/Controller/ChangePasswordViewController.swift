//
//  ChangePasswordViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 11/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var currentPassword: UITextField!
    var token = String()
    var email = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let credentials = save().getCredentials()
        self.getEmailAndToken(fromCredentials: credentials)
    }
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        if(confirmPassword.text! == newPassword.text!){
            SVProgressHUD.show()
            self.neworking()
        }else{
            //show a popup that confirm password and new password doesnot matches 
        }
    }
}

//MARK:- Networking stuff
extension ChangePasswordViewController{
    private func neworking() {
        Networking().changePassword(withCurrentPassword: self.currentPassword.text!, newPassword: self.newPassword.text!, email: self.email, andToken: self.token){ (result) in
            SVProgressHUD.dismiss()
            
            if(result){
                //Account details change done
                print("Password has been changed")
                //Show an alart to the user that its completed
            }else{
                //Account details change failes
                //handel the error if failed to change the detalies of the account
                print("password changing process failed")
            }
        }
    }
}


//MARK:- All private functions
extension ChangePasswordViewController{
    private func getEmailAndToken(fromCredentials credentials:[String:String]){
        self.token = credentials[credential.token]!
        self.email = credentials[credential.email]!
    }
}
