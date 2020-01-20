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
    
    @IBAction func staticWebPageButtonClicked(_ sender : UIButton){
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
        
        self.userName.text = "\(firstName!) \(lastName!)"
        self.userEmail.text = email!
    }
}
