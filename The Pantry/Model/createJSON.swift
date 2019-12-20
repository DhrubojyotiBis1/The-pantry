//
//  createJSON.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 20/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import Foundation
import SwiftyJSON

struct createJsonKey {
    static let productId = "product_id"
    static let quantity = "quantity"
}

class createJSON{
    var selectedproducts = [selectedProduct]()
    init(fromSelectedProducts products:[selectedProduct]) {
        self.selectedproducts = products
    }
    
    func getCreatedJSOn()->JSON{
        var jsonObject = [Any]() //= JSON([["productId":"productId","quantity":3]])
        
        for productSelected in self.selectedproducts {
            let tempDict:[String : Any] = [createJsonKey.productId:productSelected.product.productId , createJsonKey.quantity : productSelected.quantity]
            
            jsonObject.append(tempDict)
        }
        
        return (JSON(jsonObject))
    }
}
