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

struct razorPaySucessResponseKey {
    static let orderId = AnyHashable("razorpay_order_id")
    static let signature = AnyHashable("razorpay_signature")
}

protocol CheckOutViewControllerProtcol {
    func didPaymentCmplete(withsStatus status:Bool)
}


class CheckOutViewController: UIViewController {
    
    var selectedProducts = [selectedProduct]()
    var preOrderResponse:preOrderResponce!
    var razorPay:Razorpay!
    let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "test")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    @IBAction func PayButtonPressed(_ sender:UIButton){
        SVProgressHUD.show()
        self.doPreOrder()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CheckOutViewController{
    private func doPreOrder(){
        let userCredentials = save().getCredentials()
        Networking().doPreOrder(withselectedProducts: self.selectedProducts, token: userCredentials[saveCredential.token]!) { (result,preOrderResponse) in
            if(result){
                self.present(self.newViewController, animated: true) {
                    self.preOrderResponse = preOrderResponse
                    print("preOrderResponse",self.preOrderResponse)
                    self.showPaymentForm()
                }
            }else{
                SVProgressHUD.dismiss()
                print("Some Error has orrured")
            }
        }
        
    }
}

extension CheckOutViewController:RazorpayPaymentCompletionProtocolWithData{
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        let resopayOrderId = response![razorPaySucessResponseKey.orderId] as! String
        let razorPaySignature = response![razorPaySucessResponseKey.signature] as! String
        
        let usercredential = save().getCredentials()
        let token = usercredential[saveCredential.token]!
        Networking().checkTransactionStatus(withRazorPayPaymentId: payment_id, razorPayOrderId: resopayOrderId, razorPaySignature: razorPaySignature, andToken: token) { (result, massage) in
            if(result){
                //transaction done
            }else{
                //transaction failes
            }
        }
    }
    
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        print("nope")
    }
    
}


extension CheckOutViewController:CheckOutViewControllerProtcol{
    func didPaymentCmplete(withsStatus status:Bool){
        
    }
}


extension CheckOutViewController{
    private func showPaymentForm(){
        razorPay = Razorpay.initWithKey(self.preOrderResponse.key!, andDelegateWithData: self)
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
        
        print("razorPayDict",options)
        
        razorPay.open(options, display: newViewController)
        SVProgressHUD.dismiss()
    }
    
    private func setUp(){
        if let selectedProduct = save().getCartDetails(){
            self.selectedProducts = selectedProduct
        }
    }
}
