//
//  NewPasswordViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 21/02/20.
//  Copyright © 2020 coded. All rights reserved.
//

import UIKit

class NewPasswordViewController: UIViewController {

    @IBOutlet weak var newPassword:UITextField!
    @IBOutlet weak var confirmPassword:UITextField!
    var token = String()
        var email = String()
        var animationController:animation! = nil
        override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
            self.animationController = animation(animationView: self.view)
        }
        @IBAction func submitButtonPressed(_ sender: UIButton) {
            
            if(confirmPassword.text! == newPassword.text!){
                animationController.play()
                self.neworking()
            }else{
                //show a popup that confirm password and new password doesnot matches
            }
        }
        
        @IBAction func backButtonPressed(_ sender:UIButton){
            self.dismiss(animated: true, completion: nil)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.loginVCId{
            let destination = segue.destination as! LoginViewController
            destination.isPasswordChanges = true
        }
    }
    }

    //MARK:- Networking stuff
    extension NewPasswordViewController{
        private func neworking() {
            Networking().setPassword(toNewPassword: newPassword.text!, usingToken: self.token) { (result, message) in
                
                self.animationController.stop()
                
                if(result){
                    //Account details change done
                    print("Password has been changed")
                    //Show an alart to the user that its completed
                    self.performSegue(withIdentifier: segueId.loginVCId, sender: nil)
                }else{
                    //Account details change failes
                    //handel the error if failed to change the detalies of the account
                    print("password changing process failed")
                }
            }
        }
    }

