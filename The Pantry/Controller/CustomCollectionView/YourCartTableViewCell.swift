//
//  YourCartTableViewCell.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 13/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit
protocol YourCartTableViewCellDelegate {
    func removedButtonClicked(atRow row:Int)
}

protocol YourCartTableViewCellProtocol {
    func decreaseQuantity(at indexPath:Int)
    func increaseQuantity(at indexPath:Int)
}

class YourCartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productName:UILabel!
    @IBOutlet weak var removeButton:UIButton!
    @IBOutlet weak var price:UILabel!
    @IBOutlet weak var quantityLabel:UILabel!
    @IBOutlet weak var increaseQuantityButton:UIButton!
    @IBOutlet weak var decreaseQuantityButton:UIButton!
    
    var delegate:YourCartTableViewCellDelegate?
    var quantityChangeDelegate:YourCartTableViewCellProtocol?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func removeButtonClicked(_ sender:UIButton){
        delegate?.removedButtonClicked(atRow: sender.tag)
    }
    
    func removedButtonClicked(atRow row:Int){
        
    }
    
    @IBAction func increaseQuantityButtonPressed(_ sender:UIButton){
        self.quantityChangeDelegate?.increaseQuantity(at: sender.tag)
    }
    
    @IBAction func decreaseQuantityButtonPressed(_ sender:UIButton){
        self.quantityChangeDelegate?.decreaseQuantity(at: sender.tag)
    }

}
