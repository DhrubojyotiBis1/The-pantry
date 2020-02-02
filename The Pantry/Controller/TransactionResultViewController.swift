//
//  TransactionResultViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 25/01/20.
//  Copyright © 2020 coded. All rights reserved.
//

import UIKit
import SVProgressHUD

struct transactionMassage{
    static let sucess = "Your order placed successfully!"
    static let failed = "Order couldn't be placed. Please contack support."
}

class TransactionResultViewController: UIViewController {

    @IBOutlet weak var statusImage:UIImageView!
    @IBOutlet weak var status:UILabel!
    @IBOutlet weak var statusMassage:UILabel!
    
    var transactionResult = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        SVProgressHUD.show()
    }
    
    @IBAction func checkOrderBUttonPressed(_ sender:UIButton){
        performSegue(withIdentifier: segueId.transactionVCId, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.transactionVCId{
            let destination = segue.destination as! TransactionViewController
            destination.isCommingFromTransactionVC = true
            destination.delegate = self
        }
    }

}

extension TransactionResultViewController{
    private func setup(){
        switch self.transactionResult {
        case 1:
            //transaction is successful
            self.statusImage.image = UIImage.checkmark
            self.status.text = "THANK YOU"
            self.statusMassage.text = transactionMassage.sucess
            break
        case 2:
        //transaction is successful
        self.statusImage.image = UIImage(named: "cross")
        self.status.text = "ORDER FAILED"
        self.statusMassage.text = transactionMassage.failed
            break
        default:
            break
        }
    }
}

extension TransactionResultViewController:TransactionViewControllerProtocol{
    func didTransactionViewControllerDismiss() {
        print("yescalling")
        dismiss(animated: false, completion: nil)
    }
}
