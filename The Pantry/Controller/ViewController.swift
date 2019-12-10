//
//  ViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 09/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit
import DotsLoading

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.startDotAnimation()
        performSegue(withIdentifier: segueId.registrationVCId, sender: nil)
    }
}

extension ViewController{
    private func startDotAnimation(){
        //Creating loading animation
        let dotColors = [UIColor.black, UIColor.black, UIColor.black, UIColor.white]
        let loadingView = DotsLoadingView(colors: dotColors)
        self.view.addSubview(loadingView)
        //Adding contrains
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -60).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        //starting animation
       // loadingView.show()
    }
}
