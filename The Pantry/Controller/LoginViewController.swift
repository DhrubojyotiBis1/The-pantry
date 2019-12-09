//
//  LoginViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 10/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet var loginView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setup()
    }

}

extension LoginViewController{
    private func setup(){
        //make the corner of the register button round
        self.registerButton.layer.cornerRadius = 10
        
        //adding tap gesture to the view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.loginView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func onTap(){
        self.email.endEditing(true)
        self.password.endEditing(true)
    }
}
