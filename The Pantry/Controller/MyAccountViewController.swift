//
//  MyAccountViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 10/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol MyAccountProtocol {
    func didViewDismis()
}

class MyAccountViewController: UIViewController {

    @IBOutlet weak var firstNameTextField:UITextField!
    @IBOutlet weak var lastNameTextField:UITextField!
    @IBOutlet weak var phoneNumber:UILabel!
    @IBOutlet weak var emailLabel:UILabel!
    @IBOutlet weak var contentView:UIView!
    
    var credentials:[String:String]!
    var delegate:MyAccountProtocol?
    var token = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        self.setup()
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        if(firstNameTextField.text !=  "" && lastNameTextField.text !=  ""){
            SVProgressHUD.show()
            self.neworking()
        }else{
            print("firstName and lastName both are required")
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
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let email = emailLabel.text!
        let phoneNumber = self.credentials[saveCredential.phoneNumber]!
        Networking().changeAccountDetails(withFirstName: firstName, lastName: lastName, token: self.token) { (result) in
            SVProgressHUD.dismiss()
            
            if(result){
                //Account details change done
                print("Account details change done")
                //Show an alart to the user that its completed
                save().saveCredentials(withFirstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, token: self.token)
                self.delegate?.didViewDismis()
                self.dismiss(animated: true, completion: nil)
            }else{
                //Account details change failes
                //handel the error if failed to change the detalies of the account
                print("Account details change failed")
            }
        }
    }
}

extension MyAccountViewController{
    
    private func setup(){
        credentials = save().getCredentials()
        addTextIntextField(usingCredentials: credentials)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func onTap(){
        self.firstNameTextField.endEditing(true)
        self.lastNameTextField.endEditing(true)
    }
    
    private func addTextIntextField(usingCredentials credentials:[String:String]){
        
        //geting the token fand email from saved credentials
        self.emailLabel.text = credentials[saveCredential.email]!
        self.phoneNumber.text = "+91 " + credentials[saveCredential.phoneNumber]!
        self.token = credentials[saveCredential.token]!
    }
}
