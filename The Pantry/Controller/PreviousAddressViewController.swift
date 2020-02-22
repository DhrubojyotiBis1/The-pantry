//
//  PreviousAddressViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 02/02/20.
//  Copyright © 2020 coded. All rights reserved.
//

import UIKit
import SVProgressHUD

class PreviousAddressViewController: UIViewController {
    
    @IBOutlet weak var previousAddressTableView:UITableView!
    @IBOutlet weak var navigationBarView:UIView!

    var userAddress = [address]()
    var allAdress = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
        self.getPreviousAddress()
    }
    
    @IBAction func backButtonPressed(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addAddressButtonPressed(_ sender:UIButton){
        self.performSegue(withIdentifier: segueId.addAddressVCId, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.checkOutVCId{
            let destination = segue.destination as! CheckOutViewController
            destination.checkOutAddress = self.allAdress
        }
    }

}

extension PreviousAddressViewController:UITableViewDelegate,UITableViewDataSource,PreviousAddressTableViewCellProtocol{
    func proceedButtonPressed(tag: Int) {
        allAdress.append(self.userAddress[tag].billing_address_1!)
        allAdress.append(self.userAddress[tag].billing_address_2!)
        allAdress.append(self.userAddress[tag].billing_city!)
        allAdress.append(self.userAddress[tag].billing_pin!)
        allAdress.append(self.userAddress[tag].billing_state!)
        allAdress.append(self.userAddress[tag].billing_country!)
        allAdress.append(self.userAddress[tag].shipping_address_1!)
        allAdress.append(self.userAddress[tag].shipping_address_2!)
        allAdress.append(self.userAddress[tag].shipping_city!)
        allAdress.append(self.userAddress[tag].shipping_pin!)
        allAdress.append(self.userAddress[tag].shipping_state!)
        allAdress.append(self.userAddress[tag].shipping_country!)
        
        performSegue(withIdentifier: segueId.checkOutVCId, sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.previousAddressTableView.dequeueReusableCell(withIdentifier: "previousAddressTableViewCell", for: indexPath) as! PreviousAddressTableViewCell
        cell.delegate = self
        cell.proceedButton.tag = indexPath.row
        
        for i in 0..<4{
            if i == 0{
                cell.billingAddress[i].text = "\(self.userAddress[indexPath.row].billing_address_1!) ,\(self.userAddress[indexPath.row].billing_address_2!)"
                cell.shippingAddress[i].text = "\(self.userAddress[indexPath.row].shipping_address_1!) ,\(self.userAddress[indexPath.row].shipping_address_2!)"
            }
            else if i == 1{
                cell.billingAddress[i].text = "\(self.userAddress[indexPath.row].billing_city!),"
                cell.shippingAddress[i].text = "\(self.userAddress[indexPath.row].shipping_city!),"
            }else if i == 2{
                cell.billingAddress[i].text = "\(self.userAddress[indexPath.row].billing_state!)-\(self.userAddress[indexPath.row].billing_pin!),"
                cell.shippingAddress[i].text = "\(self.userAddress[indexPath.row].shipping_state!)-\(self.userAddress[indexPath.row].shipping_pin!),"
            }else{
                cell.billingAddress[i].text = "\(self.userAddress[indexPath.row].billing_country!)"
                cell.shippingAddress[i].text = "\(self.userAddress[indexPath.row].shipping_country!)"
            }
        }
        
        return cell
    }
}

extension PreviousAddressViewController{
    private func getPreviousAddress(){
        let credentials = save().getCredentials()
        let token = credentials["token"]!
        Networking().getAddress(withToken: token) { (result, address) in
            SVProgressHUD.dismiss()
            if result != false{
                if address?.count != 0{
                    self.userAddress = address!
                    self.previousAddressTableView.reloadData()
                }else{
                    //no previos address present
                    self.performSegue(withIdentifier: segueId.addAddressVCId, sender: nil)
                }
            }else{
                //network problem
                self.view.makeToast("Something went wrong", duration: 2, position: .center, completion: nil)
            }
        }
    }
    
    
}

extension PreviousAddressViewController{
    private func setup(){
        SVProgressHUD.show()
        self.previousAddressTableView.delegate = self
        self.previousAddressTableView.dataSource = self
        
        self.makeCardView(fromViews: self.navigationBarView, isViewNavigationBar: true)
    }
    
    private func makeCardView(fromViews view:UIView,isViewNavigationBar :Bool){
        //makeing the card view for the view
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.4
        if(isViewNavigationBar){
            view.layer.shadowOffset = CGSize(width: 0, height: 4.5)
        }else{
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }
}
