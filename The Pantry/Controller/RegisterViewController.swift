//
//  RegisterViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 10/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class RegisterViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet var registerView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    
    var mobileNumber = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setup()
    }
    

    @IBAction func registerButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        neworking()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == segueId.HomeVCId){
            //send the images to the home VC
        }
    }
    
    @IBAction func alreadyhaveAnAcountButtonPressed(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- Networking stuff
extension RegisterViewController{
    private func neworking() {
        
        for _ in 0..<2{
             mobileNumber.removeFirst()
        }
        
        Networking().checkRegistration(withFirstName: firstName.text!, lastName: lastName.text!, email: email.text!, password: password.text!,phoneNumber : mobileNumber){success,massage in
            SVProgressHUD.dismiss()
            if(success){
                print("Done registration")
                //take the user to the next page
                self.performSegue(withIdentifier: segueId.HomeVCId, sender: nil)
            }else{
                print("Failed")
                //show the alart that the registration is failed
                let VC = ViewController()
                VC.showMassage(withMassage: massage!, havingMassageType: .error, toViewController: self) {
                    print(massage as Any)
                }
            }
            
        }
        
    }
}

extension RegisterViewController{
    private func setup(){
        //Changing the corner radius of the register button
        self.registerButton.layer.cornerRadius = 10
        
        //adding tab gesture feature to the register view
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(onTab))
        self.registerView.addGestureRecognizer(tabGesture)
        
        let VC = ViewController()
        VC.makeCardView(forButton: self.registerButton)
    }
    
    @objc private func onTab(){
        self.firstName.endEditing(true)
        self.lastName.endEditing(true)
        self.email.endEditing(true)
        self.password.endEditing(true)
    }
}
