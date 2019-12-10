//
//  MyAccountViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 10/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController {

    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
            let credentials = save().getCredentials()
            print(credentials)
            addTextIntextField(usingCredentials: credentials)
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        print("working")
    }
}

extension MyAccountViewController{
    private func addTextIntextField(usingCredentials credentials:[String:String]){
        self.firstName.text = credentials[credential.firstName]
        self.lastName.text = credentials[credential.lastName]
        self.email.text = credentials[credential.email]
    }
}
