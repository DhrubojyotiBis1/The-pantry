//
//  TransactionTableViewCell.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 20/01/20.
//  Copyright © 2020 coded. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var satatusBackgroungWidth: NSLayoutConstraint!
    @IBOutlet weak var idAndProductPriceTableView: UITableView!
    @IBOutlet weak var statusLable:UILabel!
    @IBOutlet weak var statusBackground:UIView!
    @IBOutlet weak var orderId:UILabel!
    @IBOutlet weak var date:UILabel!
    @IBOutlet weak var totalCost:UILabel!
    
    var previousOrderProduct = [selectedProduct]()
    var totalPrice = String()
    var quantity = Int()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.idAndProductPriceTableView.delegate = self
        self.idAndProductPriceTableView.dataSource = self
    }

}

extension TransactionTableViewCell:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.previousOrderProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.idAndProductPriceTableView.dequeueReusableCell(withIdentifier: "TransactionHistoryIdAndPriceTableViewCell") as! TransactionHistoryIdAndPriceTableViewCell
        cell.productID.text = self.previousOrderProduct[indexPath.row].product.name + " x \(self.previousOrderProduct[indexPath.row].quantity)"
        cell.productPrice.text = self.previousOrderProduct[indexPath.row].product.sellingPrice
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
