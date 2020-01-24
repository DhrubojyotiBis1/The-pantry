//
//  TransactionHistoryIdAndPriceTableViewCell.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 24/01/20.
//  Copyright © 2020 coded. All rights reserved.
//

import UIKit

class TransactionHistoryIdAndPriceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productID: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
