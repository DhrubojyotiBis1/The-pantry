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
    func checkRegistration(withFirstName firstname:String,lastName:String,email:String,password:String,completion: @escaping (_ result:Bool,_ massage:String?) -> ()){
        let pram = [registeAndLoginPram.firstName:firstname,  registeAndLoginPram.lastName:lastName, registeAndLoginPram.password:password, registeAndLoginPram.email:email]
        
        Alamofire.request(url.registerURL ,method: .post , parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
                //Registration is success
                //Handel the error casses
                //Using the login to get the token
                let userJSON : JSON = JSON(response.result.value!)
                print(userJSON)
                if(userJSON["message"].string == "success"){
                    self.CheckforLogin(withEmail : email,andPassword :password, comingfromLoginVC: false){result , token in
                        if(result){
                            //saveing the credentials
                            save().saveCredentials(withFirstName: firstname, lastName: lastName, email: email, token: token)
                            completion(true,userJSON["message"].string!)
                            
                        }else{
                            //Registration complete but not getting token "Something went wrong"
                            completion(false,userJSON["message"].string! )
                        }
                    }
                }else{
                    //registration failed as already register
                    completion(false,userJSON["message"].string! )
                }
            }else{
                //Registration is failed
                completion(false,nil)
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
                            self.downloadImage(havingUrls: urls) { (result) in
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
                            self.downloadImage(havingUrls: urls) { (result) in
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
    
    func downloadImage(havingUrls urls: [String.SubSequence]? ,completion:@escaping (_ result:Bool/*,_ images:[UIImage]?*/)->()){
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
    func getListOfProducts(forCatagory catagory:String,completion:@escaping (_ result : Bool,_ productList: [product])->()){
        
        let pram = [productCatagory.productCatagoryPram : catagory]
        Alamofire.request(url.productListURL ,method: .post , parameters : pram).responseJSON { (response) in
            var products = [product]()
            if response.result.isSuccess{
              //Got the product detals
                let userJSON : JSON = JSON(response.result.value!)
                //par's the userJSON
                //make a class name product details along with urls
                //store each product in product details class arry
                //send the arry back
                print("getListOfProducts \(userJSON)")
                for i in 0..<userJSON.count{
                    let name = userJSON[i]["name"].string!
                    let sellingPrice = userJSON[i]["selling price"].string!
                    let productId = "\(userJSON[i]["pid"])"
                    let productDescription =  ""//userJSON[i]["description"].string!
                    let newproduct = product(name: name, sellingPrice: sellingPrice,productId: productId,productDescription:productDescription)
                    products.append(newproduct)
                }
                completion(true,products)
            }else{
                //fail to get the product details
                completion(false,products)
            }
        }
    }
    
    //to get the user cart details
    func getUserCartDetails(withUserToken token:String,completion:@escaping (_ result:Bool,_ cartdetails:[cartProduct]?)->()){
        let pram = [responceKey.token : token]
        Alamofire.request(url.cartDetailsURL, parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
              //Got the cart detals
                let cartProductDetails : JSON = JSON(response.result.value!)
                //par's the userJSON
                //make a class name product details
                //store each product in product details class arry
                //send the arry back
                //handel the token expired error
                print(cartProductDetails)
                var productInCart = [cartProduct]()
                for i in 0..<cartProductDetails.count{
                    let productId = cartProductDetails[i][cartDetailsKey.productId].string!
                    let quantity = cartProductDetails[i][cartDetailsKey.quantity].int!
                    let productDetails = cartProduct(quantity: quantity, productID: productId)
                    productInCart.append(productDetails)
                }
                completion(true,productInCart)
            }else{
                //fail to get the cart details
               completion(false,nil)
            }
        }
    }
    
    //to update the cart
    func updateCartDetais(withToken token:String,cartDetails details:[selectedProduct]){
        let detailsJson = createJSON(fromSelectedProducts: details).getCreatedJSOn()
        let pram:[String:Any] = [userCart.token : token,userCart.details:detailsJson]
        Alamofire.request(url.updateCartURL,method: .post ,parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
              //Got the cart detals
                let userJSON : JSON = JSON(response.result.value!)
                print(userJSON)
                //completion(true)
            }else{
                //fail to get the cart details
                //completion(false)
            }
        }
    }
    
    //For OTP varification
    func getOtp(withPhoneNumber phoneNumber:String,completion:@escaping (_ result:Bool,_ type:String)->()){
        //request failing if massage is included in parameter
        let pram = [smsGateWay.authenticationKey:smsGateWayConstants.authenticationKey,smsGateWay.phoneNumber : phoneNumber,smsGateWay.otpExpiryTimeing:smsGateWayConstants.expiryTime,smsGateWay.headingOfTheSended:smsGateWayConstants.heading,smsGateWay.otpLength:smsGateWayConstants.lengthOfOtp]
        //trying to do networking for varification
        Alamofire.request(url.getOtpURL,method: .get ,parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
              //networking done
                let userJSON : JSON = JSON(response.result.value!)
                print(userJSON)
                if(userJSON[smsGateWay.type].string! == smsGateWayConstants.smsSendSuccessType){
                    //take to the next view controller for otp Varification
                    completion(true,userJSON[smsGateWay.type].string!)
                }else{
                    //failed to send otp
                    completion(false,userJSON[smsGateWay.type].string!)
                    print(userJSON[smsGateWay.type])
                }
                
            }else{
                //fail to do networking
                completion(false,"Network Error")
                print(response.error?.localizedDescription as Any)
            }
        }
    }
    
    
    //For OTP varification
    func otpVarification(withOtp otp:String,andPhoneNumber phoneNumber:String,completion:@escaping (_ result:Bool,_ type:String)->()){
        let pram = [smsGateWay.authenticationKey:smsGateWayConstants.authenticationKey,smsGateWay.phoneNumber : phoneNumber,smsGateWay.otp:otp]
        //trying to do networking for varification
        Alamofire.request(url.varifyOtpURL,method: .get ,parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
              //networking done
                let userJSON : JSON = JSON(response.result.value!)
                print(userJSON)
                if(userJSON[smsGateWay.type].string! == smsGateWayConstants.smsSendSuccessType){
                    //otp varification uccess
                    //take to the next view controller
                    completion(true,userJSON[smsGateWay.type].string!)
                }else{
                    //failed to varify otp
                    completion(false,userJSON["message"].string!)
                }
            }else{
                //fail to do networking
                print(response.error?.localizedDescription as Any)
                completion(false,"Network Error")
            }
        }
    }
    
    //For resending the same otp 
    func resendOtp(forPhoneNumber phoneNumber:String,completion:@escaping (_ result:Bool,_ token:Int)->()){
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
                    completion(true,1)
                }else{
                    //failed to varify otp
                    print(userJSON[smsGateWay.type])
                    completion(false,2)
                }
            }else{
                //fail to do networking
                print(response.error?.localizedDescription as Any)
                completion(false,0)
            }
        }
    }
    
    //For sending massages
    func sendMassage(toPhoneNumber phoneNumber:String,completion:@escaping (_ result:Bool)->()){
        let param = [smsGateWay.authenticationKey : smsGateWayConstants.authenticationKey,smsGateWay.phoneNumberForSendingSms:phoneNumber,smsGateWay.headingOfTheSended:smsGateWayConstants.heading,smsGateWay.message:smsGateWayConstants.transactionMassage,smsGateWay.route:smsGateWayConstants.transactionRoute]
        
        //trying to do networking to send massage
        Alamofire.request(url.sendTransactionalAndPromotionalMassageURL,method: .get ,parameters : param).responseString { (response) in
            if response.result.isSuccess{
              //networking done
                //if response.result.value!.cout is 16 then the massage is send
                 print(response.result.value!)
            }else{
                //fail to do networking
                print(response.error?.localizedDescription as Any)
            }
        }
        
    }
    
    
    //for getting the product description
    func getProductDetails(fromProductId productId:String,completion:@escaping (_ resul:Bool,_ productDetails:product?)->()){
        let param = ["pid":productId]
        
        
        Alamofire.request(url.productDescriptionURl,method: .get ,parameters : param).responseJSON { (response) in
            if response.result.isSuccess{
              //networking done
                //if response.result.value!.cout is 16 then the massage is send
                let productDetails:JSON = JSON(response.result.value!)
                print(productDetails)
                let name = productDetails[productkey.productDetails][productkey.name].string!
                let sellingPrice = productDetails[productkey.productDetails][productkey.sellingPrice].string!
                let description = productDetails[productkey.productDetails][productkey.productDescription].string!
                let productId = "\(productDetails[productkey.productDetails][productkey.productId].int!)"
                
                let cartProduct = product(name: name, sellingPrice: sellingPrice, productId: productId, productDescription: description)
                
                completion(true,cartProduct)
                
            }else{
                //fail to do networking
                completion(false,nil)
                print(response.error?.localizedDescription as Any)
            }
        }
    }
    
    func doPreOrder(withselectedProducts selectedProducts:[selectedProduct],token:String,PhoneNumber :String , billingAddress1 :String,billingAddress2 : String,billingCity : String,billingPin:String , billingState:String , billingCountry:String, shipingAddress1 :String,shipingAddress2 : String,shipingCity : String,shipingPin:String , shipingState:String , shipingCountry:String,completion:@escaping (_ result :Bool,_ preOrderResponce:preOrderResponce)->()){
        
        
        let orderJson = createJSON(fromSelectedProducts: selectedProducts).getCreatedJSOn()
        let param:[String:Any] = [preOrderKey.token:token,preOrderKey.itemOrdered:orderJson,preOrderKey.phoneNumber : PhoneNumber,preOrderKey.billingAddress1:billingAddress1,preOrderKey.billingAddress2:billingAddress2,preOrderKey.billingCity:billingCity,preOrderKey.billingPin : billingPin , preOrderKey.billingState : billingState,preOrderKey.billingCountry : billingCountry,preOrderKey.shipingAddress1:shipingAddress1,preOrderKey.shipingAddress2:shipingAddress2,preOrderKey.shipingCity:shipingCity,preOrderKey.shipingPin : shipingPin , preOrderKey.shipingState : shipingState,preOrderKey.shipingCountry : shipingCountry]
        
        Alamofire.request(url.prepareOrderURL,method: .post ,parameters : param).responseJSON { (response) in
            if response.result.isSuccess{
              //networking done
                let responce = JSON(response.result.value!)
                print("doPreOrder \(responce)")
                if(responce[preOrderResponseKey.razorPayOrderId].string != nil){
                    let amount = Double(responce[preOrderResponseKey.amount].int!)
                    let razorPayKey = responce[preOrderResponseKey.razorPaykey].string!
                    let orderId = responce[preOrderResponseKey.razorPayOrderId].string!
                    let customerEmail = responce[preOrderResponseKey.customerEmail].string!
                    
                    let preOrderResponse = preOrderResponce(totalAmoutToBePaid:amount , customerEmail: customerEmail, key: razorPayKey, razorPayOrderId: orderId,massage: preOrderResponseKey.sucessMassage)
                    completion(true,preOrderResponse)
                }
                else{
                    let preOrderResponse = preOrderResponce(totalAmoutToBePaid: nil, customerEmail: nil, key: nil, razorPayOrderId: nil, massage: "preOrder not Dode")
                    completion(false,preOrderResponse)
                }
                
            }else{
                //fail to do networking
                print(response.error?.localizedDescription as Any)
                let preOrderResponse = preOrderResponce(totalAmoutToBePaid: nil, customerEmail: nil, key: nil, razorPayOrderId: nil, massage: "Network error")
                completion(false, preOrderResponse)
            }
        }
    }
    
    func checkTransactionStatus(withRazorPayPaymentId paymentId:String,razorPayOrderId orderId : String,razorPaySignature signature :String,andToken token:String,completion:@escaping(_ result:Bool,_ massage:String?)->()){
        
        let param:[String:String] = [razorPayTransactionkey.token:token,razorPayTransactionkey.signature:signature,razorPayTransactionkey.paymentId:paymentId,razorPayTransactionkey.razorPayOrderId:orderId]
        
        Alamofire.request(url.transactionStatus,method: .post ,parameters : param).responseJSON { (response) in
                   if response.result.isSuccess{
                     //networking done
                       //if response.result.value!.cout is 16 then the massage is send
                        print("response",response.result.value!)
                   }else{
                       //fail to do networking
                       print(response.error?.localizedDescription as Any)
                   }
               }
        
    }
    
    //for getting product catagories
    func getCatgories(withToken token:String){
        
        let param = [responceKey.token : token]
        
        Alamofire.request(url.catagoryURl,method: .get ,parameters : param).responseJSON { (response) in
            if response.result.isSuccess{
              //networking done
                 print("response",response.result.value!)
            }else{
                //fail to do networking
                print(response.error?.localizedDescription as Any)
            }
        }
        
    }
    
    func getTransactionHistory(withToken token:String,completion:@escaping(_ result:Int, _ transactionHistory:[order]?)->()){
        
        let param = [responceKey.token : token]
        
        Alamofire.request(url.transactionHistoryURL,method: .get ,parameters : param).responseJSON { (response) in
            if response.result.isSuccess{
                 //networking done
                print("getTransactionHistory",response.result.value!)
                let transactionHistoryJSON = JSON(response.result.value!)
                if transactionHistoryJSON.count > 0{
                    var transactionHistory = [order]()
                    for i in 0..<transactionHistoryJSON.count{
                        let orderDate = transactionHistoryJSON[i][transactionKey.orderDate].string!.split(separator: " ")
                        let orderID = transactionHistoryJSON[i][transactionKey.orderId].int!
                        let isPaymentSucess:Int!
                        if let sucess = transactionHistoryJSON[i][transactionKey.isSucess].int{
                            isPaymentSucess = sucess
                        }else{
                            isPaymentSucess = 0
                        }
                        let transactionOrder = order(orderDate: "\(orderDate[0])", orderId: orderID, isOrderSuccess: isPaymentSucess)
                        transactionHistory.append(transactionOrder)
                    }
                    completion(1,transactionHistory)
                    return
                }
                completion(-1,nil)
            }else{
                //fail to do networking
                print(response.error?.localizedDescription as Any)
                completion(0,nil)
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

