//
//  TransactionTableViewCell.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 20/01/20.
//  Copyright © 2020 coded. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statusLable:UILabel!
    @IBOutlet weak var statusBackground:UIView!
    @IBOutlet weak var orderId:UILabel!
    @IBOutlet weak var date:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
