//
//  ProfileViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 10/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func changePasswordButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: segueId.changePasswordVCId, sender: nil)
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: segueId.editProfileVCId, sender: nil)
    }
}
