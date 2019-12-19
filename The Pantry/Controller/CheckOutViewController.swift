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
    
    var razorPay:Razorpay?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func payButtonPressed(_ sender:UIButton){
        self.showPaymentForm()
        
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


//MARK:- networking
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
                        "contact": "9797979797",
                        "email": "foo@bar.com"
                    ],
            razorPayCredentials.colourTheme: razorPayConstant.theme
                ]
        
        self.razorPay?.open(options)
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController

        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }

        return topMostViewController
    }

}

extension CheckOutViewController:RazorpayPaymentCompletionProtocol{
    func onPaymentError(_ code: Int32, description str: String) {
        SVProgressHUD.showError(withStatus: "Payment Failed")
        
        print("code: \(code)")
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        SVProgressHUD.showSuccess(withStatus: "Payment Completed")
    }
    
    
}
