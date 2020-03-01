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
protocol TransactionViewControllerProtocol {
    func didTransactionViewControllerDismiss()
}

class TransactionViewController: UIViewController {
    
    @IBOutlet weak var transactionTableView:UITableView!
    @IBOutlet weak var topNavigationView:UIView!
    
    var transactionHistory = [order]()
    var orderedProduct = [[selectedProduct]]()
    var recomendedProduct = [product]()
    var totalCost = [String]()
    var isCommingFromTransactionVC = false
    var delegate:TransactionViewControllerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    @IBAction func backButtonPressed(_ sender:UIButton){
        if self.isCommingFromTransactionVC {
            self.getRecomendedProduct()
            SVProgressHUD.show()
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.HomeVCId{
            let destination = segue.destination as! HomeViewController
            destination.recomendedProducts = self.recomendedProduct
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
        
        if(transactionHistory[indexPath.row].isOrderSuccess == 2){
            cell.statusBackground.backgroundColor = UIColor(red: 120/255, green: 202/255, blue: 40/255, alpha: 1)
            cell.statusLable.text = "Completed"
            cell.satatusBackgroungWidth.constant = 80
        }else if transactionHistory[indexPath.row].isOrderSuccess == 1{
           cell.statusBackground.backgroundColor = UIColor.systemRed
            cell.statusLable.text = "Canceled"
            cell.satatusBackgroungWidth.constant = 70
        }else if transactionHistory[indexPath.row].isOrderSuccess == 3{
            cell.statusBackground.backgroundColor = UIColor.systemOrange
            cell.statusLable.text = "On Hold"
            cell.satatusBackgroungWidth.constant = 70
        }else if transactionHistory[indexPath.row].isOrderSuccess == 4{
            cell.statusBackground.backgroundColor = UIColor(red: 255/255, green: 196/255, blue: 0/255, alpha: 1)
            cell.statusLable.text = "Processing"
            cell.satatusBackgroungWidth.constant = 80
        }else if transactionHistory[indexPath.row].isOrderSuccess == 5{
            cell.statusBackground.backgroundColor = UIColor.systemOrange
            cell.statusLable.text = "Pending"
            cell.satatusBackgroungWidth.constant = 70
        }else if transactionHistory[indexPath.row].isOrderSuccess == 6{
            cell.statusBackground.backgroundColor = UIColor.systemRed
            cell.statusLable.text = "Refunded"
            cell.satatusBackgroungWidth.constant = 70
        }else{
            cell.statusBackground.backgroundColor = UIColor(red: 120/255, green: 202/255, blue: 40/255, alpha: 1)

            cell.statusLable.text = "Pending Payment"
            cell.satatusBackgroungWidth.constant = 120
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
            if orderedProduct[indexPath.row].count == 1{
                slaveTableViewCellHight += 15
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
    
    private func getRecomendedProduct(){
        let catagory = "recommended-for-you"
        Networking().getListOfProducts(forCatagory: catagory) { (result, recomendedProducts) in
            self.recomendedProduct = recomendedProducts
            self.performSegue(withIdentifier: segueId.HomeVCId, sender: nil)
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
