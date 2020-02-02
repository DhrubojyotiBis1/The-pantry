//
//  PreviousAddressTableViewCell.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 02/02/20.
//  Copyright © 2020 coded. All rights reserved.
//

import UIKit

protocol PreviousAddressTableViewCellProtocol {
    func proceedButtonPressed(tag:Int)
}

class PreviousAddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellContentView:UIView!
    @IBOutlet weak var proceedButton:UIButton!
    @IBOutlet var shippingAddress:[UILabel]!
    @IBOutlet var billingAddress:[UILabel]!
    var delegate:PreviousAddressTableViewCellProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.makeCardView(fromViews: self.cellContentView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func proceedButtonPressed(_ sender:UIButton){
        self.delegate?.proceedButtonPressed(tag: sender.tag)
    }

}

extension PreviousAddressTableViewCell{
    private func makeCardView(fromViews view:UIView){
        //makeing the card view for the view
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.cornerRadius = 5
    }
}
