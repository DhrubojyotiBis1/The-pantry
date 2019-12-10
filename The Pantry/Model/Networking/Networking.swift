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

public class Networking{
    
    //For Registration
    func checkRegistration(withFirstName firstname:String,lastName:String,email:String,password:String,completion: @escaping (_ result:Bool) -> ()){
        let pram = [registeAndLoginPram.firstName:firstname,  registeAndLoginPram.lastName:lastName, registeAndLoginPram.password:password, registeAndLoginPram.email:email]
        
        Alamofire.request(url.registerURL ,method: .post , parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
                //Registration is success
                //Handel the error casses
                //Using the login to get the token
                self.CheckforLogin(withEmail : email,andPassword :password, comingfromLoginVC: false){result , token in
                    if(result){
                        //saveing the credentials
                        save().saveCredentials(withFirstName: firstname, lastName: lastName, email: email, token: token)
                            completion(true)
                        
                    }else{
                        //Registration complete but not getting token "Something went wrong"
                        completion(false)
                    }
                }
            }else{
                //Registration is failed
                completion(false)
            }
        }
    }
    
    //For login
    func CheckforLogin(withEmail email:String,andPassword password:String,comingfromLoginVC : Bool,completion: @escaping(_ result:Bool,_ token:String)->()){
        let pram = [registeAndLoginPram.password:password, registeAndLoginPram.email:email]
        
        Alamofire.request(url.loginURL ,method: .post , parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
                //Registration is success
                let userJSON : JSON = JSON(response.result.value!)
                print(userJSON)
                
                //checking if the login coming from loginVC or from registerVC to get the token
                if(comingfromLoginVC){
                    //Checking if login is Successfull
                    if(userJSON[responceKey.token].string != nil){
                        save().saveCredentials(withFirstName: userJSON[responceKey.firstName].string!, lastName: userJSON[responceKey.lastName].string!, email: email, token: userJSON[responceKey.token].string!)
                        completion(true,"nil")
                    }else{
                        //Something went wrong not loged in
                        //handel the error with a Popup
                        completion(false,"nil")
                    }
                }else{
                    //Sending the token to the checkRegistration
                    if(userJSON[responceKey.token].string != nil){
                        completion(true,userJSON[responceKey.token].string!)
                    }else{
                        //login failde hence no token
                        completion(false,"nil")
                    }
                }
            }else{
                //Registration is failed
                completion(false, "login faild")
            }
        }
    }
    
    //For account detalis change
    func changeAccountDetails(withFirstName firstName:String,lastName:String,email:String,token:String,password:String,completion: @escaping(_ result:Bool)->()){
        
        
        let pram = [registeAndLoginPram.firstName:firstName,  registeAndLoginPram.lastName:lastName, registeAndLoginPram.password:password, registeAndLoginPram.email:email,responceKey.token:token]
        
        Alamofire.request(url.changeAccountDetailsURL ,method: .post , parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
              
                let userJSON : JSON = JSON(response.result.value!)
                print(userJSON)
                completion(true)
            }else{
                //Account detalis change is failed
                completion(false)
            }
        }
        
    }
}

