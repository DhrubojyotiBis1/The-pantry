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

protocol CheckOutViewControllerProtcol {
    func didPaymentCmplete(withsStatus status:Bool)
}


class CheckOutViewController: UIViewController {
    
    var selectedProducts = [selectedProduct]()
    var preOrderResponse = preOrderResponce()
    var delegate:CheckOutViewControllerProtcol?
    var razorPay:Razorpay!
    let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "test")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.selectedProducts)
    }
    
    @IBAction func PayButtonPressed(_ sender:UIButton){
        SVProgressHUD.show()
        self.doPreOrder()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        save().saveCartDetais(withDetails: self.selectedProducts)
        delegate?.didPaymentCmplete(withsStatus: false)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CheckOutViewController{
    private func doPreOrder(){
        let userCredentials = save().getCredentials()
        Networking().doPreOrder(withselectedProducts: self.selectedProducts, token: userCredentials[saveCredential.token]!) { (result,preOrderResponse) in
            if(result){
                self.present(self.newViewController, animated: true) {
                    SVProgressHUD.dismiss()
                    self.preOrderResponse = preOrderResponse
                    self.showPaymentForm()
                }
            }else{
                SVProgressHUD.dismiss()
                print("Some Error has orrured")
            }
        }
    }
}

extension CheckOutViewController:RazorpayPaymentCompletionProtocol{
    func onPaymentError(_ code: Int32, description str: String) {
        
        print("ops \(str)")
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        //All the transaction api to check if transaction is completed or not
        delegate?.didPaymentCmplete(withsStatus: true)
        print("done \(payment_id)")
    }
    
    
}


extension CheckOutViewController:CheckOutViewControllerProtcol{
    func didPaymentCmplete(withsStatus status:Bool){
        
    }
}


extension CheckOutViewController{
    private func showPaymentForm(){
        razorPay = Razorpay.initWithKey(self.preOrderResponse.key!, andDelegate: self)
        let options: [String:Any] = [
            razorPayCredentials.amaount: self.preOrderResponse.totalAmoutToBePaid!, //This is in currency subunits. 100 = 100 paise= INR 1.
            razorPayCredentials.currency: razorPayConstant.currency,//We support more that 92 international currencies.
            razorPayCredentials.description: "purchase description",
            razorPayCredentials.orderId: self.preOrderResponse.razorPayOrderId!,
            razorPayCredentials.imageUrl: "ss",
            razorPayCredentials.name: "Test",
            razorPayCredentials.contactProfile: [
                        "contact": "8961388276",
                        "email": self.preOrderResponse.customerEmail!
                    ],
            razorPayCredentials.colourTheme: razorPayConstant.theme
                ]
        razorPay.open(options, display: newViewController)
        SVProgressHUD.dismiss()
    }
}
