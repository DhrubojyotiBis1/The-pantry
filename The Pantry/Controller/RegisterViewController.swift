//
//  RegisterViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 10/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet var registerView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setup()
    }


}

extension RegisterViewController{
    private func setup(){
        //Changing the corner radius of the register button
        self.registerButton.layer.cornerRadius = 10
        
        //adding tab gesture feature to the register view
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(onTab))
        self.registerView.addGestureRecognizer(tabGesture)
    }
    
    @objc private func onTab(){
        self.firstName.endEditing(true)
        self.lastName.endEditing(true)
        self.email.endEditing(true)
        self.password.endEditing(true)
    }
}
