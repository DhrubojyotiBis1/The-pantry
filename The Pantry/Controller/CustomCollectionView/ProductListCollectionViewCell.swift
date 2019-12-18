//
//  ProductListCollectionViewCell.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 13/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit

protocol ProductListCollectionViewCellDelegate {
   func cellAddButton(haveTag tag : [Int])
}

class ProductListCollectionViewCell: UICollectionViewCell {
    
    var section = Int()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var productImage:UIImageView!
    @IBOutlet weak var productPrice:UILabel!
    @IBOutlet weak var productName:UILabel!
    @IBOutlet weak var productAddButton:UIButton!
    @IBOutlet weak var cellView:UIView!
    var delegate: ProductListCollectionViewCellDelegate?
    
    @IBAction func addButtonPressed(_ sender:UIButton){
        let tag = [self.section,sender.tag]
        delegate?.cellAddButton(haveTag: tag)
    }
    
}


extension ProductListCollectionViewCell{
    func cellAddButton(haveTag tag : [Int]){}
}
