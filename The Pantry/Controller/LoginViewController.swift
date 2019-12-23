//
//  LoginViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 10/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet var loginView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        self.neworking()
    }
 
    @IBAction func dontHaveAccountButtonPressed(_ sender : UIButton){
        self.performSegue(withIdentifier: segueId.enterMobileNumberVcId, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == segueId.HomeVCId){
            //send the images to the home VC
        }
    }
    
}

//MARK:- Networking stuff
extension LoginViewController{
    private func neworking() {
        Networking().CheckforLogin(withEmail: self.email.text!, andPassword: self.password.text!, comingfromLoginVC: true){success,token in
            SVProgressHUD.dismiss()
            if(success){
                //save the credential for auto login
                print("Login done")
                //Going to the HomeViewController
                self.performSegue(withIdentifier: segueId.HomeVCId, sender: nil)
            }else{
                //show alar for the faliur of login
                print("login failed \(token)")
            }
        }
    }
}

extension LoginViewController{
    private func setup(){
        //make the corner of the register button round
        self.registerButton.layer.cornerRadius = 10
        
        //adding tap gesture to the view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.loginView.addGestureRecognizer(tapGesture)
        self.makeCardView(forButton: self.registerButton)
    }
    
    @objc private func onTap(){
        self.email.endEditing(true)
        self.password.endEditing(true)
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
