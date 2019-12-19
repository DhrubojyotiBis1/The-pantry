//
//  CheckOutViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 18/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit
import Razorpay
import SVProgressHUD

class CheckOutViewController: UIViewController {
    
    var razorPay:Razorpay!
    let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "test")
    
    @IBAction func PayButtonPressed(_ sender:UIButton){
        SVProgressHUD.show()
        self.present(newViewController, animated: true) {
            self.showPaymentForm()
        }
    }
}

extension CheckOutViewController:RazorpayPaymentCompletionProtocol{
    func onPaymentError(_ code: Int32, description str: String) {
        print("ops \(str)")
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        print("done \(payment_id)")
    }
    
    
}

extension CheckOutViewController{
    private func showPaymentForm(){
        razorPay = Razorpay.initWithKey(razorPayCredentials.key, andDelegate: self)
        let options: [String:Any] = [
            razorPayCredentials.amaount: "100", //This is in currency subunits. 100 = 100 paise= INR 1.
            razorPayCredentials.currency: razorPayConstant.currency,//We support more that 92 international currencies.
            razorPayCredentials.description: "purchase description",
            /*razorPayCredentials.orderId: "order_4xbQrmEoA5WJ0G",*/
            razorPayCredentials.imageUrl: "ss",
            razorPayCredentials.name: "Test",
            razorPayCredentials.contactProfile: [
                        "contact": "8961388276",
                        "email": "foo@bar.com"
                    ],
            razorPayCredentials.colourTheme: razorPayConstant.theme
                ]
        razorPay.open(options, display: newViewController)
        SVProgressHUD.dismiss()
    }
}
