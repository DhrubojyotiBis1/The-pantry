//
//  networking.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 10/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct registeAndLoginPram {
    static let firstName = "first_name"
    static let lastName = "last_name"
    static let email = "email"
    static let password = "password"
}

public class Networking{
    
    //For login
    func checkRegistration(withFirstName firstname:String,lastName:String,email:String,password:String,completion: @escaping (_ result:Bool) -> ()){
        let pram = [registeAndLoginPram.firstName:firstname,  registeAndLoginPram.lastName:lastName, registeAndLoginPram.password:password, registeAndLoginPram.email:email]
        
        Alamofire.request(url().registerURL ,method: .post , parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
                //Registration is success
                let userJSON : JSON = JSON(response.result.value!)
                print(userJSON)
                completion(true)
            }else{
                //Registration is failed
                completion(false)
            }
        }
    }
    
    func CheckforLogin(withEmail email:String,andPassword password:String,completion: @escaping(_ result:Bool)->()){
        let pram = [registeAndLoginPram.password:password, registeAndLoginPram.email:email]
        
        Alamofire.request(url().loginURL ,method: .post , parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
                //Registration is success
                let userJSON : JSON = JSON(response.result.value!)
                print(userJSON)
                completion(true)
            }else{
                //Registration is failed
                completion(false)
            }
        }
    }
}

