//
//  ProfileViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 10/12/19.
//  Copyright © 2019 coded. All rights reserved.
//
import SafariServices
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userName:UILabel!
    @IBOutlet weak var userEmail:UILabel!
    @IBOutlet weak var phoneNumber:UILabel!
    var stringUrlForSelectedPage:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
        
    }
    
    @IBAction func changePasswordButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: segueId.changePasswordVCId, sender: nil)
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        save().removeCredentials()
        save().removeItemAddedToCart()
        performSegue(withIdentifier: segueId.loginVCId, sender: nil)
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: segueId.editProfileVCId, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.editProfileVCId{
            let destination = segue.destination as! MyAccountViewController
            destination.delegate = self
        }
    }
    
    @IBAction func backButtonPressed(_ sender :UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension ProfileViewController{
    
    private func setup(){
        let credentials = save().getCredentials()
        let firstName = credentials[saveCredential.firstName]
        let lastName = credentials[saveCredential.lastName]
        let email = credentials[saveCredential.email]
        let phoneNUmber = credentials[saveCredential.phoneNumber]
        
        self.userName.text = "\(firstName!) \(lastName!)"
        self.userEmail.text = email!
        self.phoneNumber.text = "+91 " + phoneNUmber!
    }
}

extension ProfileViewController:MyAccountProtocol{
    func didViewDismis() {
        self.setup()
        self.view.makeToast("Update Successful", duration: 2, position: .center, completion: nil)
    }
}
