//
//  TransactionViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 20/01/20.
//  Copyright © 2020 coded. All rights reserved.
//

import UIKit
import Toast_Swift
import SVProgressHUD

class TransactionViewController: UIViewController {
    
    @IBOutlet weak var transactionTableView:UITableView!
    @IBOutlet weak var topNavigationView:UIView!
    
    var transactionHistory = [order]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }
    
    @IBAction func backButtonPressed(_ sender:UIButton){
        dismiss(animated: true, completion: nil)
    }
}

extension TransactionViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.transactionTableView.dequeueReusableCell(withIdentifier: "transactionTableViewCell") as! TransactionTableViewCell
        
        cell.date.text = transactionHistory[indexPath.row].orderDate
        cell.orderId.text = "Order Id #\(String(describing: transactionHistory[indexPath.row].orderId!))"
        
        if(transactionHistory[indexPath.row].isOrderSuccess == 1){
            cell.statusBackground.backgroundColor = UIColor(red: 120/255, green: 202/255, blue: 40/255, alpha: 1)
            cell.statusLable.text = "Order Placed"
        }else{
            cell.statusBackground.backgroundColor = UIColor.red
            cell.statusLable.text = "Order Pending"
        }
        
        return cell
    }
}


extension TransactionViewController{
    
    private func getTransactionHistory(){
        let credentials = save().getCredentials()
        let token = credentials[responceKey.token]!
        Networking().getTransactionHistory(withToken: token) { (result, transactionHistory) in
            SVProgressHUD.dismiss()
            if result == 1 {
                self.transactionHistory = transactionHistory!
                self.transactionTableView.reloadData()
            }else if result == -1{
                self.view.makeToast(massage.noDataInHistory, duration: massage.duration, position: .center)
            }else{
                self.view.makeToast(massage.somethingWentWrong, duration: massage.duration, position: .center)
            }
        }
    }
    
    private func setup(){
        SVProgressHUD.show()
        
        self.transactionTableView.delegate = self
        self.transactionTableView.dataSource = self
        
        self.topNavigationView.layer.masksToBounds = false
        self.topNavigationView.layer.shadowColor = UIColor.gray.cgColor
        self.topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.topNavigationView.layer.shadowOpacity = 0.4
        
        self.getTransactionHistory()
    }
}
