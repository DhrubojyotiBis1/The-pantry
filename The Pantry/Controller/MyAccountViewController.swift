//
//  MyAccountViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 10/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit
import SVProgressHUD

class MyAccountViewController: UIViewController {

    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    var email = String()
    var token = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
            let credentials = save().getCredentials()
            addTextIntextField(usingCredentials: credentials)
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        if(confirmPassword.text! == newPassword.text!){
            SVProgressHUD.show()
            self.neworking()
        }else{
            print("newPassword and confirmPassword is not equal")
            //Handel the error
        }
    }
    
    @IBAction func backButtonPressed(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- Networking stuff
extension MyAccountViewController{
    private func neworking() {
        Networking().changeAccountDetails(withFirstName: firstName.text!, lastName: lastName.text!, email: self.email, token: self.token, password: newPassword.text!) { (result) in
            SVProgressHUD.dismiss()
            
            if(result){
                //Account details change done
                print("Account details change done")
                //Show an alart to the user that its completed
            }else{
                //Account details change failes
                //handel the error if failed to change the detalies of the account
                print("Account details change failed")
            }
        }
    }
}

extension MyAccountViewController{
    private func addTextIntextField(usingCredentials credentials:[String:String]){
        //setting the credentials to the textField
        self.firstName.text = credentials[saveCredential.firstName]
        self.lastName.text = credentials[saveCredential.lastName]
        
        //geting the token fand email from saved credentials
        self.email = credentials[saveCredential.email]!
        self.token = credentials[saveCredential.token]!
    }
}
