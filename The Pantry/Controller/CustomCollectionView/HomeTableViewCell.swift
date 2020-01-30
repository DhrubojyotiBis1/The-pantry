//
//  HomeTableViewCell.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 29/01/20.
//  Copyright © 2020 coded. All rights reserved.
//

import UIKit

protocol HomeTableViewCellProtocol {
    
    func addButtonPressed(tag:Int)
    func subButtonPressed(tag:Int)
}


class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImage:UIImageView!
    @IBOutlet weak var productName:UILabel!
    @IBOutlet weak var productDiscription:UILabel!
    @IBOutlet weak var productQuantity:UILabel!
    @IBOutlet weak var cellView:UIView!
    @IBOutlet weak var addButton:UIButton!
    @IBOutlet weak var subtractButton:UIButton!
    @IBOutlet weak var productSellingPrice:UILabel!
    var delegate:HomeTableViewCellProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.makeCardView(fromViews: self.cellView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addButtonPressed(_ sender:UIButton){
        delegate?.addButtonPressed(tag: sender.tag)
    }
    
    @IBAction func subtractButtonPressed(_ sender:UIButton){
        delegate?.subButtonPressed(tag: sender.tag)
    }
    
    private func makeCardView(fromViews view:UIView){
        //makeing the card view for the view
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.cornerRadius = 8
    }

}
