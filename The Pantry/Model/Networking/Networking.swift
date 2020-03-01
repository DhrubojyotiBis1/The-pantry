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
    func checkRegistration(withFirstName firstname:String,lastName:String,email:String,password:String,phoneNumber:String,completion: @escaping (_ result:Bool,_ massage:String?,_ bannerImages:[UIImage?]) -> ()){
        let pram = [registeAndLoginPram.firstName:firstname,  registeAndLoginPram.lastName:lastName, registeAndLoginPram.password:password, registeAndLoginPram.email:email,registeAndLoginPram.phoneNumeber:phoneNumber]
        
        var bannerImages = [UIImage?]()
        
        Alamofire.request(url.registerURL ,method: .post , parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
                //Registration is success
                //Handel the error casses
                //Using the login to get the token
                let userJSON : JSON = JSON(response.result.value!)
                print("checkRegistration \(userJSON)")
                if(userJSON["message"].string == "success"){
                    self.CheckforLogin(withEmail : email,andPassword :password, comingfromLoginVC: false){result , token, images  in
                        if(result){
                            //saveing the credentials
                            save().saveCredentials(withFirstName: firstname, lastName: lastName, email: email, phoneNumber: phoneNumber, token: token)
                            bannerImages = images
                            completion(true,userJSON["message"].string!, bannerImages)
                            
                        }else{
                            //Registration complete but not getting token "Something went wrong"
                            completion(false,userJSON["message"].string!, bannerImages )
                        }
                    }
                }else{
                    //registration failed as already register
                    completion(false,userJSON["message"].string!, bannerImages )
                }
            }else{
                //Registration is failed
                completion(false,"Network Problem!", bannerImages)
            }
        }
    }
    
    //For login
    func CheckforLogin(withEmail email:String,andPassword password:String,comingfromLoginVC : Bool,completion: @escaping(_ result:Bool,_ token:String,_ bannerImages:[UIImage?])->()){
        let pram = [registeAndLoginPram.password:password, registeAndLoginPram.email:email]
        
        var bannerImages = [UIImage?]()
        
        Alamofire.request(url.loginURL ,method: .post , parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
                //No network issue
                let userJSON : JSON = JSON(response.result.value!)
                //checking if the login coming from loginVC or from registerVC to get the token
                print("CheckforLogin \(userJSON)")
                if(comingfromLoginVC){
                    //Checking if login is Successfull
                    if(userJSON[responceKey.token].string != nil){
                        save().saveCredentials(withFirstName: userJSON[responceKey.firstName].string!, lastName: userJSON[responceKey.lastName].string!, email: email, phoneNumber: userJSON[responceKey.phoneNumber].string!, token: userJSON[responceKey.token].string!)
                        
                        
                        self.downloadImageForHomePage { (_, images) in
                            bannerImages = images
                            completion(true,userJSON[responceKey.token].string!, bannerImages)
                        }
                    }else{
                        //no toket found
                        //Something went wrong not
                        //handel the error with a Popup
                        completion(false,"Wrong password!", bannerImages)
                    }
                }else{
                    //Sending the token to the checkRegistration
                    if(userJSON[responceKey.token].string != nil){
                        
                        //Download image using url.downloadImageURL
                        
                        self.downloadImageForHomePage { (_, images) in
                            bannerImages = images
                            completion(true,userJSON[responceKey.token].string!, bannerImages)
                        }
                    }else{
                        //login failde hence no token
                        completion(false,"nil", bannerImages)
                        print("email id used")
                    }
                }
            }else{
                //Registration is failed
                completion(false, "Registration faild", bannerImages)
            }
        }
    }
    
    //For account detalis change
    func changeAccountDetails(withFirstName firstName:String,lastName:String,token:String,completion: @escaping(_ result:Bool)->()){
        
        
        let pram = [registeAndLoginPram.firstName:firstName,  registeAndLoginPram.lastName:lastName,responceKey.token:token]
        
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
    
    func downloadImageForHomePage(/*havingUrls urls: String? ,*/completion:@escaping (_ result:Bool,_ images:[UIImage?])->()){
        let dispatchGroup = DispatchGroup()
        var bannerImage = [UIImage?]()
        self.getAdsImageURLForHomeViewControllerBanner { (result, urls) in
            for i in 0..<urls!.count{
                var tempImage:UIImage?
                dispatchGroup.enter()
                Alamofire.request("\(urls![i])").responseData{ (response) in
                    if response.error == nil{
                        print("yes")
                        if let data = response.data {
                            print("yes1")
                            tempImage = UIImage(data: data)!
                        }
                    }else{
                        tempImage = nil
                    }
                    dispatchGroup.leave()
                    bannerImage.append(tempImage)
                }
            }
            dispatchGroup.notify(queue: .main) {
                completion(true,bannerImage)
            }
        }
        /*if(urls != nil){
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
        }*/
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
                    var tempImageURL = [String]()
                    let name = userJSON[i]["name"].string!
                    let sellingPrice = userJSON[i]["selling price"].string!
                    let productId = "\(userJSON[i]["pid"])"
                    let productDescription =  userJSON[i]["short_description"].string!
                    if userJSON[i]["images"].count > 0 {
                        for j in 0..<userJSON[i]["images"].count{
                            if let imageURL = userJSON[i]["images"][j]["path"].string{
                                tempImageURL.append(imageURL)
                            }
                        }
                    }
                    let newproduct = product(name: name, sellingPrice: sellingPrice,productId: productId,productDescription:productDescription,imageURL: tempImageURL)
                    products.append(newproduct)
                }
                print(products)
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
                print("getUserCartDetails \(cartProductDetails)")
                var productInCart = [cartProduct]()
                for i in 0..<cartProductDetails.count{
                    let productId = cartProductDetails[i][cartDetailsKey.productId].string!
                    let quantity = cartProductDetails[i][cartDetailsKey.quantity].int!
                    let productDetails = cartProduct(quantity: quantity, productID: productId)
                    productInCart.append(productDetails)
                }
                if productInCart.count == 0{
                   completion(true,nil)
                }else{
                    completion(true,productInCart)
                }
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
                print("getProductDetails: \(productDetails)")
                let name = productDetails[productkey.productDetails][productkey.name].string!
                let sellingPrice = productDetails[productkey.productDetails][productkey.sellingPrice].string!
                let description = productDetails[productkey.productDetails][productkey.productDescription].string!
                let productId = "\(productDetails[productkey.productDetails][productkey.productId].int!)"
                var imagesUrl = [String]()
                if let imageUrl = productDetails["images"]["path"].string{
                    imagesUrl.append(imageUrl)
                }
                let cartProduct = product(name: name, sellingPrice: sellingPrice, productId: productId, productDescription: description, imageURL: imagesUrl)
                
                completion(true,cartProduct)
                
            }else{
                //fail to do networking
                completion(false,nil)
                print(response.error?.localizedDescription as Any)
            }
        }
    }
    
    func doPreOrder(withselectedProducts selectedProducts:[selectedProduct],token:String,PhoneNumber :String , billingAddress1 :String,billingAddress2 : String,billingCity : String,billingPin:String , billingState:String , billingCountry:String, shipingAddress1 :String,shipingAddress2 : String,shipingCity : String,shipingPin:String , shipingState:String , shipingCountry:String,coupon:String?,completion:@escaping (_ result :Bool,_ preOrderResponce:preOrderResponce)->()){
        
        
        let orderJson = createJSON(fromSelectedProducts: selectedProducts).getCreatedJSOn()
        
        var param:[String:Any]!
        
        if coupon != nil{
            param = [preOrderKey.coupon:coupon!,preOrderKey.token:token,preOrderKey.itemOrdered:orderJson,preOrderKey.phoneNumber : PhoneNumber,preOrderKey.billingAddress1:billingAddress1,preOrderKey.billingAddress2:billingAddress2,preOrderKey.billingCity:billingCity,preOrderKey.billingPin : billingPin , preOrderKey.billingState : billingState,preOrderKey.billingCountry : billingCountry,preOrderKey.shipingAddress1:shipingAddress1,preOrderKey.shipingAddress2:shipingAddress2,preOrderKey.shipingCity:shipingCity,preOrderKey.shipingPin : shipingPin , preOrderKey.shipingState : shipingState,preOrderKey.shipingCountry : shipingCountry]
        }else{
            
            param = [preOrderKey.token:token,preOrderKey.itemOrdered:orderJson,preOrderKey.phoneNumber : PhoneNumber,preOrderKey.billingAddress1:billingAddress1,preOrderKey.billingAddress2:billingAddress2,preOrderKey.billingCity:billingCity,preOrderKey.billingPin : billingPin , preOrderKey.billingState : billingState,preOrderKey.billingCountry : billingCountry,preOrderKey.shipingAddress1:shipingAddress1,preOrderKey.shipingAddress2:shipingAddress2,preOrderKey.shipingCity:shipingCity,preOrderKey.shipingPin : shipingPin , preOrderKey.shipingState : shipingState,preOrderKey.shipingCountry : shipingCountry]
            
        }
        
        print("doPreOrder \(param)")
        
        Alamofire.request(url.prepareOrderURL,method: .post ,parameters : param).responseJSON { (response) in
            if response.result.isSuccess{
              //networking done
                let responce = JSON(response.result.value!)
                print("doPreOrder2 \(responce)")
                if(responce[preOrderResponseKey.razorPayOrderId].string != nil){
                    let amount = Double(responce[preOrderResponseKey.amount].int!)
                    let razorPayKey = responce[preOrderResponseKey.razorPaykey].string!
                    let orderId = responce[preOrderResponseKey.razorPayOrderId].string!
                    let customerEmail = responce[preOrderResponseKey.customerEmail].string!
                    
                    let preOrderResponse = preOrderResponce(totalAmoutToBePaid:amount , customerEmail: customerEmail, key: razorPayKey, razorPayOrderId: orderId,massage: preOrderResponseKey.sucessMassage)
                    completion(true,preOrderResponse)
                }
                else{
                    let preOrderResponse = preOrderResponce(totalAmoutToBePaid: nil, customerEmail: nil, key: nil, razorPayOrderId: nil, massage: responce["error"].string!)
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
    
    func checkTransactionStatus(withRazorPayPaymentId paymentId:String,razorPayOrderId orderId : String,razorPaySignature signature :String,andToken token:String,completion:@escaping(_ result:Int,_ massage:String?)->()){
        
        let param:[String:String] = [razorPayTransactionkey.token:token,razorPayTransactionkey.signature:signature,razorPayTransactionkey.paymentId:paymentId,razorPayTransactionkey.razorPayOrderId:orderId]
        
        Alamofire.request(url.transactionStatus,method: .post ,parameters : param).responseJSON { (response) in
                   if response.result.isSuccess{
                     //networking done
                       //if response.result.value!.cout is 16 then the massage is send
                        print("response",response.result.value!)
                        let userResponse  = JSON(response.result.value!)
                        let massage = userResponse["message"].string!
                    //if networking is done then i am assuming transaction is complete
                        completion(1,massage)
                   }else{
                       //fail to do networking
                        completion(0,"Network Problem")
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
    
    func getTransactionHistory(withToken token:String,completion:@escaping(_ result:Int, _ transactionHistory:[order]?,_ products:[[selectedProduct]]?,_ totalAmount:[String]?)->()){
        
        let param = [responceKey.token : token]
        
        Alamofire.request(url.transactionHistoryURL,method: .get ,parameters : param).responseJSON { (response) in
            if response.result.isSuccess{
                 //networking done
                print("getTransactionHistory",response.result.value!)
                let transactionHistoryJSON = JSON(response.result.value!)
                if transactionHistoryJSON.count > 0{
                    var transactionHistory = [order]()
                    var productOrder = [[selectedProduct]]()
                    var tempARRAY = [selectedProduct]()
                    var totalAmount = [String]()
                    for i in 0..<transactionHistoryJSON.count{
                        let orderDate = transactionHistoryJSON[i][transactionKey.orderDate].string!.split(separator: " ")
                        let orderID = transactionHistoryJSON[i][transactionKey.orderId].int!
                        let isPaymentSucess:Int!
                        if transactionHistoryJSON[i]["status"].string! == "pending_payment"{
                            isPaymentSucess = 0
                        }else if transactionHistoryJSON[i]["status"].string! == "canceled"{
                            isPaymentSucess = 1
                        }else if transactionHistoryJSON[i]["status"].string! == "completed"{
                            isPaymentSucess = 2
                        }else if transactionHistoryJSON[i]["status"].string! == "on_hold"{
                            isPaymentSucess = 3
                        }else if transactionHistoryJSON[i]["status"].string! == "processing"{
                            isPaymentSucess = 4
                        }else if transactionHistoryJSON[i]["status"].string! == "pending"{
                           isPaymentSucess = 5
                        }else{
                            //refunded
                            isPaymentSucess = 6
                        }
                        let transactionOrder = order(orderDate: "\(orderDate[0])", orderId: orderID, isOrderSuccess: isPaymentSucess)
                        transactionHistory.append(transactionOrder)
                        
                        for j in 0..<transactionHistoryJSON[i]["products"].count{
                            let name = transactionHistoryJSON[i]["products"][j]["name"].string!
                            let sellingPrice = transactionHistoryJSON[i]["products"][j]["unit_price"].string!
                            let productId = "\(transactionHistoryJSON[i]["products"][j]["id"].int!)"
                            let quantity = transactionHistoryJSON[i]["products"][j]["quantity"].int!
                            let orderProduct = product(name: name, sellingPrice: sellingPrice, productId: productId, productDescription: "")
                            let newOrder = selectedProduct(product: orderProduct, quantity: quantity)
                            tempARRAY.append(newOrder)
                            
                        }
                        productOrder.append(tempARRAY)
                        tempARRAY.removeAll()
                        let total = transactionHistoryJSON[i]["total"].string!
                        totalAmount.append(total)
                        
                    }
                    completion(1,transactionHistory, productOrder, totalAmount)
                    return
                }
                completion(-1,nil, nil, nil)
            }else{
                //fail to do networking
                print(response.error?.localizedDescription as Any)
                completion(0,nil, nil, nil)
            }
        }

        
    }
    
    func downloadImageForProduct(withURL url:String,completion:@escaping (_ images:UIImage?)->()){
        var tempImage:UIImage?
        Alamofire.request(url).responseData{ (response) in
            if response.error == nil{
                if let data = response.data {
                    if let image = UIImage(data: data){
                        tempImage = image
                    }else{
                        tempImage = nil
                    }
                }else{
                    tempImage = nil
                }
            }else{
                tempImage = nil
            }
            completion(tempImage)
        }
    }
    
    func getAddress(withToken token:String,completion:@escaping (_ resut:Bool,_ address:[address]?)->()){
        let param = ["token":token]
        Alamofire.request(url.addressURL,method: .get ,parameters : param).responseData{ (response) in
            if response.result.isSuccess{
                let addressJSON = JSON(response.result.value!)
                var userAddress = [address]()
                print("address",addressJSON)
                for i in 0..<addressJSON.count{
                    let billing_address_1 = addressJSON[i]["billing_address_1"].string!
                    let billing_address_2 = addressJSON[i]["billing_address_2"].string!
                    let billing_city = addressJSON[i]["billing_city"].string!
                    let billing_state = addressJSON[i]["billing_state"].string!
                    let billing_pin = addressJSON[i]["billing_pin"].string!
                    let billing_country = addressJSON[i]["billing_country"].string!
                    let shipping_address_1 = addressJSON[i]["shipping_address_1"].string!
                    let shipping_address_2 = addressJSON[i]["shipping_address_2"].string!
                    let shipping_city = addressJSON[i]["shipping_city"].string!
                    let shipping_state = addressJSON[i]["shipping_state"].string!
                    let shipping_pin = addressJSON[i]["shipping_pin"].string!
                    let shipping_country = addressJSON[i]["shipping_country"].string!
                    
                    let tempAddress = address(billing_address_1: billing_address_1, billing_address_2: billing_address_2, billing_city: billing_city, billing_state: billing_state, billing_pin: billing_pin, billing_country: billing_country, shipping_address_1: shipping_address_1, shipping_address_2: shipping_address_2, shipping_city: shipping_city, shipping_state: shipping_state, shipping_pin: shipping_pin, shipping_country: shipping_country)
                    userAddress.append(tempAddress)
                }
                
                completion(true,userAddress)
            }else{
                completion(false,nil)
            }
        }
    }
    
    func applyCoupon(withCouponCode couponCode:String,andAmount amount:String,completion:@escaping ()->()){
           
           let param = ["coupon":couponCode,"amaount":amount]
           
        Alamofire.request(url.couponURL,method: .post ,parameters : param).responseJSON { (response) in
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
    
    func getForgetPassordOTP(toPhoneNumber phoneNumber:String,completion:@escaping(_ result:Bool,_ token:String)->()){
        let pram = ["phone":phoneNumber]
        //trying to do networking for varification
        Alamofire.request(url.forgetPasswordOtpURL,method: .post ,parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
              //networking done
                let userJSON : JSON = JSON(response.result.value!)
                print("forgotPassoword",userJSON)
                if(userJSON[smsGateWay.message].string! == smsGateWayConstants.smsSendSuccessType){
                    //take to the next view controller for otp Varification
                    completion(true,userJSON["token"].string!)
                }else{
                    //failed to send otp
                    completion(false,userJSON[smsGateWay.message].string!)
                }
                
            }else{
                //fail to do networking
                completion(false,"Network Error")
                print(response.error?.localizedDescription as Any)
            }
        }
    }
    
    func varifyParrowordForForgetpassword(withOtp otp:String,andToken token:String,completion:@escaping (_ result:Bool,_ token:String?)->()){
        
        let pram = ["otp":otp,"token":token]
        
        Alamofire.request(url.newPasswordURL,method: .post ,parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
              //networking done
                let userJSON : JSON = JSON(response.result.value!)
                print("varifyParrowordForForgetpassword",userJSON)
                if userJSON["token"].string != nil{
                    if(userJSON[smsGateWay.message].string! == smsGateWayConstants.smsSendSuccessType){
                        //take to the next view controller for otp Varification
                        completion(true,userJSON["token"].string!)
                    }
                }else{
                    //failed to send otp
                    completion(false,userJSON[smsGateWay.message].string!)
                }
                
            }else{
                //fail to do networking
                completion(false,"Network Error")
                print(response.error?.localizedDescription as Any)
            }
        }
        
    }
    
    func setPassword(toNewPassword newPassword:String,usingToken Token:String ,completion:@escaping(_ result:Bool,_ type:String)->()){
        
        let pram = ["new_password":newPassword,"token":Token]
        
        Alamofire.request(url.newPasswordURL,method: .post ,parameters : pram).responseJSON { (response) in
            if response.result.isSuccess{
              //networking done
                let userJSON : JSON = JSON(response.result.value!)
                print("setPassword",userJSON)
                if(userJSON[smsGateWay.message].string! == smsGateWayConstants.smsSendSuccessType){
                    //take to the next view controller for otp Varification
                    completion(true,userJSON[smsGateWay.message].string!)
                }else{
                    //failed to send otp
                    completion(false,userJSON[smsGateWay.message].string!)
                }
                
            }else{
                //fail to do networking
                completion(false,"Network Error")
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
                print("getAdsImageURLForHomeViewControllerBanner \(userjson)")
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

