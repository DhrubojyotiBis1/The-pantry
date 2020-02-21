//
//  massage.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 21/02/20.
//  Copyright © 2020 coded. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func show(message:String) {
        let alert = UIAlertController(title: "Ops", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
}
