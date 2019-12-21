//
//  createJSON.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 20/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import Foundation
import SwiftyJSON

struct cartDetailsKey {
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
            let tempDict:[String : Any] = [cartDetailsKey.productId:productSelected.product.productId,cartDetailsKey.quantity:productSelected.quantity]
            
            jsonObject.append(tempDict)
        }
        
        //let jsonData = try! JSONSerialization.data(withJSONObject: jsonObject)
        //let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        
        return (JSON(jsonObject))
    }
}
