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
    var orderedProduct = [[selectedProduct]]()
    var totalCost = [String]()
    var isCommingFromTransactionVC = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }
    
    @IBAction func backButtonPressed(_ sender:UIButton){
        if self.isCommingFromTransactionVC {
            performSegue(withIdentifier: segueId.HomeVCId, sender: nil)
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
}

extension TransactionViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(1)
        return transactionHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(5)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionTableViewCell") as! TransactionTableViewCell
        cell.previousOrderProduct = self.orderedProduct[indexPath.row]
        cell.totalCost.text = "Total: " + self.totalCost[indexPath.row]
        cell.idAndProductPriceTableView.reloadData()
        cell.date.text = transactionHistory[indexPath.row].orderDate
        cell.orderId.text = "Order Id #\(String(describing: transactionHistory[indexPath.row].orderId!))"
        
        if(transactionHistory[indexPath.row].isOrderSuccess == 1){
            cell.statusBackground.backgroundColor = UIColor(red: 120/255, green: 202/255, blue: 40/255, alpha: 1)
            cell.statusLable.text = "Placed"
        }else{
            cell.statusBackground.backgroundColor = UIColor.systemYellow
            cell.statusLable.text = "Pending"
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var slaveTableViewCellHight:Double = 0
        if orderedProduct[indexPath.row].count > 4{
            slaveTableViewCellHight = 78
        }else{
            slaveTableViewCellHight = 85
            if orderedProduct[indexPath.row].count == 4{
                slaveTableViewCellHight -= 4
            }
        }
        let hight = CGFloat(Double(orderedProduct[indexPath.row].count)*slaveTableViewCellHight + 50 + 25)
        return hight;
    }
}


extension TransactionViewController{
    
    private func getTransactionHistory(){
        let credentials = save().getCredentials()
        let token = credentials[responceKey.token]!
        Networking().getTransactionHistory(withToken: token) { (result, transactionHistory,productOrder,totalPrice)   in
            SVProgressHUD.dismiss()
            if result == 1 {
                self.transactionHistory = transactionHistory!
                self.orderedProduct = productOrder!
                self.totalCost = totalPrice!
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
