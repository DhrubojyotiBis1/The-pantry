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
                let userJSON : JSON = JSON(response.result.value!)
                if(userJSON[credential.email].string != nil){
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
                    //registration failed as already register
                    completion(false)
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
                //No network issue
                let userJSON : JSON = JSON(response.result.value!)
                //checking if the login coming from loginVC or from registerVC to get the token
                if(comingfromLoginVC){
                    //Checking if login is Successfull
                    if(userJSON[responceKey.token].string != nil){
                        save().saveCredentials(withFirstName: userJSON[responceKey.firstName].string!, lastName: userJSON[responceKey.lastName].string!, email: email, token: userJSON[responceKey.token].string!)
                        
                        //getting each urls from the json
                        let urls = self.getUrls(fromJson: userJSON)
                        
                        //checkng if urls are valid or not
                        if(urls != nil){
                            //if we get the valid url then only download of the image is possible
                            self.downloadImageForHomeViewControllerBanner(havingUrls: urls) { (result) in
                                if(result){
                                    //login complate along with downloading of the images
                                    completion(true,"download of image complete"/*,images:[uiImage]?*/)
                                }else{
                                    //login complate but downloading of the images fails
                                    completion(true,"download of image failed"/*,images:[uiImage]?*/)
                                }
                            }
                        }else{
                            //when we dont get the url
                            completion(true,"faulty urls"/*,images:[uiImage]?*/)
                        }
                    }else{
                        //no toket found
                        //Something went wrong not
                        //handel the error with a Popup
                        completion(false,"wrong password")
                    }
                }else{
                    //Sending the token to the checkRegistration
                    if(userJSON[responceKey.token].string != nil){
                        
                        //getting each urls from the json
                        let urls = self.getUrls(fromJson: userJSON)
                        
                        //checkng if urls are valid or not
                        if(urls != nil){
                            //if we get the valid url then only download of the image is possible
                            self.downloadImageForHomeViewControllerBanner(havingUrls: urls) { (result) in
                                if(result){
                                    //Registation complate along with downloading of the images
                                    completion(true,userJSON[responceKey.token].string!/*,images:[uiImage]?*/)
                                    print("download of image complete")
                                }else{
                                    //Registation complate but downloading of the images fails
                                    completion(true,userJSON[responceKey.token].string!/*,images:[uiImage]?*/)
                                    print("download of the image fails")
                                }
                            }
                        }else{
                            //when we dont get the url
                            completion(true,userJSON[responceKey.token].string!/*,images:[uiImage]?*/)
                            print("download of image not possible")
                        }
                    }else{
                        //login failde hence no token
                        completion(false,"nil")
                        print("email id used")
                    }
                }
            }else{
                //Registration is failed
                completion(false, "Registration faild")
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
    
    
    func changePassword(withCurrentPassword password:String,newPassword : String,email:String,andToken token:String,completion: @escaping (_ result:Bool)->()){
        //email, password, new_password, token
        let pram = [registeAndLoginPram.email:email,registeAndLoginPram.password:password,registeAndLoginPram.newPassword:newPassword,responceKey.token:token]
        
        Alamofire.request(url.changePasswordURL ,method: .post , parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
              //Password change is complete
                let userJSON : JSON = JSON(response.result.value!)
                print(userJSON)
                if(userJSON["message"] != "password mismatch"){
                    completion(true)
                }else{
                    completion(false)
                }
                
            }else{
                //Password change is failed
                completion(false)
            }
        }

    }
    
    func downloadImageForHomeViewControllerBanner(havingUrls urls: [String.SubSequence]? ,completion:@escaping (_ result:Bool/*,_ images:[UIImage]?*/)->()){
        if(urls != nil){
            //coming from the loginVC or registerVC
            //have the urls
            //start downloading the image
            // if image download done send it via completion handeler
            completion(true)
            //if image download fail's call the completion handeler with "false" value
            //completion(false,nil)
        }else{
            //coming from the ViewController
            //getting the urls
            self.getAdsImageURLForHomeViewControllerBanner { (result, urls) in
                if(result){
                    //Got the url
                    //start downloading the image
                    // if image download done send it via completion handeler
                    completion(true)
                    //if image download fail's call the completion handeler with "false" value
                    //completion(false,nil)
                }else{
                    completion(false)
                }
            }
        }
    }
    
    
    //to get the product details
    func getListOfProducts(forCatagory catagory:String,completion:@escaping (_ result : Bool/*,productList: [productDetals] */)->()){
        
        let pram = [productCatagory.productCatagoryPram : catagory]
        Alamofire.request(url.productListURL ,method: .post , parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
              //Got the product detals
                //let userJSON : JSON = JSON(response.result.value!)
                //par's the userJSON
                //make a class name product details
                //store each product in product details class arry
                //send the arry back
                completion(true)
            }else{
                //fail to get the product details
                completion(false)
            }
        }
    }
    
    //to get the user cart details
    func getUserCartDetails(withUserToken token:String,completion:@escaping (_ result:Bool/*,cartdetails:userCartdetails */)->()){
        let pram = [responceKey.token : token]
        Alamofire.request(url.cartDetailsURL, parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
              //Got the cart detals
                let userJSON : JSON = JSON(response.result.value!)
                //par's the userJSON
                //make a class name product details
                //store each product in product details class arry
                //send the arry back
                print(userJSON)
                completion(true)
            }else{
                //fail to get the cart details
                completion(false)
            }
        }
    }
    
    //to update the cart
    func updateCartDetais(withToken token:String,cartDetails details:String,completion:@escaping (_ result:Bool)->()){
        let pram = [userCart.token : token,userCart.details:details] 
        Alamofire.request(url.updateCartURL,method: .post ,parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
              //Got the cart detals
                let userJSON : JSON = JSON(response.result.value!)
                print(userJSON)
                completion(true)
            }else{
                //fail to get the cart details
                completion(false)
            }
        }
    }
    
    //For OTP varification
    func getOtp(withPhoneNumber phoneNumber:String){
        let pram = [smsGateWay.authenticationKey:smsGateWayConstants.authenticationKey,smsGateWay.phoneNumber : phoneNumber,smsGateWay.otpExpiryTimeing:smsGateWayConstants.expiryTime]
        //trying to do networking for varification
        Alamofire.request(url.getOtpURL,method: .get ,parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
              //networking done
                let userJSON : JSON = JSON(response.result.value!)
                print(userJSON)
                if(userJSON[smsGateWay.type].string! == smsGateWayConstants.smsSendSuccessType){
                    //take to the next view controller for otp Varification
                    
                }else{
                    //failed to send otp
                    print(userJSON[smsGateWay.type])
                }
                
            }else{
                //fail to do networking
                print(response.error?.localizedDescription as Any)
            }
        }
    }
    
    
    //For OTP varification
    func otpVarification(withOtp otp:String,andPhoneNumber phoneNumber:String){
        let pram = [smsGateWay.authenticationKey:smsGateWayConstants.authenticationKey,smsGateWay.phoneNumber : phoneNumber,smsGateWay.otp:otp]
        //trying to do networking for varification
        Alamofire.request(url.varifyOtpURL,method: .get ,parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
              //networking done
                let userJSON : JSON = JSON(response.result.value!)
                if(userJSON[smsGateWay.type].string! == smsGateWayConstants.smsSendSuccessType){
                    //otp varification uccess
                    //take to the next view controller
                }else{
                    //failed to varify otp
                    print(userJSON[smsGateWay.type])
                }
            }else{
                //fail to do networking
                print(response.error?.localizedDescription as Any)
            }
        }
    }
    
    //For resending the same otp 
    func resendOtp(forPhoneNumber phoneNumber:String){
        let pram = [smsGateWay.authenticationKey:smsGateWayConstants.authenticationKey,smsGateWay.phoneNumber : phoneNumber,smsGateWay.reciveType:smsGateWayConstants.reciveType]
        //trying to do networking for varification
        Alamofire.request(url.reSendOtpURL,method: .get ,parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
              //networking done
                let userJSON : JSON = JSON(response.result.value!)
                if(userJSON[smsGateWay.type].string! == smsGateWayConstants.smsSendSuccessType){
                    //otp varification uccess
                    //take to the next view controller
                    print(userJSON)
                }else{
                    //failed to varify otp
                    print(userJSON[smsGateWay.type])
                }
            }else{
                //fail to do networking
                print(response.error?.localizedDescription as Any)
            }
        }
    }
    
}

//For private functions
extension Networking{
    private func getAdsImageURLForHomeViewControllerBanner(completion:@escaping (_ result:Bool,_ imageURLs:[String.SubSequence]?)->()){
        Alamofire.request(url.downloadImageURL).responseJSON { (response) in
            if response.result.isSuccess{
                let userjson:JSON = JSON(response.result.value!)
                //getting each urls
                let urls = self.getUrls(fromJson: userjson)
                if(urls != nil){
                    //if we get the url then only download of the image is possible
                    completion(true, urls)
                }else{
                    //when we dont get the url just garbage value
                    completion(false,nil)
                }
            }else{
                print("Error")
                completion(false,nil)
            }
        }
    }
    
    private func getUrls(fromJson json:JSON)->[String.SubSequence]?{
        //getting each urls by spliting the string contains the urls seperated by ,
        let urls = json["data"]["banners"].string?.split(separator: ",")
        return urls
    }
}

