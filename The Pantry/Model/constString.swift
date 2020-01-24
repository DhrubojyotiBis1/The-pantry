//
//  segueId.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 10/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import Foundation

struct segueId{
    static let registrationVCId = "goToRegisterVC"
    static let loginVCId = "goToLoginVC"
    static let changePasswordVCId = "goToChangePassword"
    static let editProfileVCId = "goToEditProfile"
    static let HomeVCId = "goToHomeVC"
    static let yourCartVC = "goToyourCartVC"
    static let productListVC = "goToProductListVC"
    static let productDescriptionVCId = "goToProductDescriptionVC"
    static let loginWithPhoneNumberVCId = "goToLoginWithPhoneNumberPageVC"
    static let otpvaruficationVCId = "goToOtpVarificationVC"
    static let threeDotPopVCId = "goToThreeDotPopUpVC"
    static let profileVCId = "goToProfileVC"
    static let checkOutVCId = "goToCheckOutVC"
    static let razorPayVCId = "goToRazorPayVC"
    static let enterMobileNumberVcId = "goToEnterMobileNumberVC"
    static let addressVC = "goToAddressVC"
    static let transactionVCId = "goToTransactionVC"
    static let transactionResult = "goToTransactionResultVC"
}

struct registeAndLoginPram {
    static let firstName = "first_name"
    static let lastName = "last_name"
    static let email = "email"
    static let password = "password"
    static let newPassword = "new_password"
    static let phoneNumeber = "phone"
}

struct  responceKey {
    static let firstName = "firstname"
    static let lastName = "lastname"
    static let token = "token"
    static let phoneNumber = "phone"
}

struct cellIdentifier {
    static let adsCellID = "adsCustomCollectionViewCell"
    static let productListCellID = "productListCollectionViewCell"
    static let yourCartCellID = "yourCartTableViewCell"
    static let productDescrptionCellID = "productDescriptionCell"
    static let productDescriptionCollectionViewCellID = "productDescriptionCollectionViewCell"
}

struct productCatagory{
    static let veg = "vegetarian"
    static let nonVeg = "non-veg"
    static let readyToEat = "ready-to-eat"
    static let merchandise = "merchandise"
    static let productCatagoryPram = "cat"
}

struct userCart {
    static let details = "cart_details"
    static let token = "token"
}

struct webPageURL {
    static let FAQ = "http://gourmetatthepantry.com/public/faq"
    static let privacyPolicy = "http://gourmetatthepantry.com/public/privacy"
    static let aboutUs = "http://gourmetatthepantry.com/public/about"
}

struct smsGateWay {
    static let otp = "otp"
    static let phoneNumber = "mobile"
    static let authenticationKey = "authkey"
    static let reciveType = "retrytype"
    static let headingOfTheSended = "sender"
    static let message = "message"
    static let otpExpiryTimeing = "otp_expiry"
    static let type = "type"
    static let route = "route"
    static let countryToSendMassage = "country"
    static let phoneNumberForSendingSms = "mobiles"
    static let otpLength = "otp_length"
}

struct smsGateWayConstants {
    static let authenticationKey = "308673A7RsGaro625df870d5"
    static let reciveType = "text"
    static let heading = "PANTRY"
    static let otpMessage = "##Dear Customer,\n734399 is your one time password (OTP). Please enter the OTP to proceed.\nThank you,\nTeam Jio.##"
    static let expiryTime = "1"
    static let smsSendSuccessType = "success"
    static let transactionMassage = "You order has been recived"
    static let promotionMassage = "This is a promotion massage"
    static let transactionRoute = "4"
    static let promotionRoute = "1"
    static let india = "91"
    static let international = "0"
    static let usa = "1"
    static let lengthOfOtp = "4"
}


struct razorPayCredentials {
    static let amaount = "amount"
    static let currency = "currency"
    static let description = "description"
    static let orderId = "order_id"
    static let imageUrl = "image"
    static let name = "name"
    static let contactProfile = "prefill"
    static let colourTheme = "theme"
}

struct razorPayConstant {
    static let currency = "INR"
    static let purchaseDescription = "purchase description"
    static let theme = ["color": "#78CA28"]
}

struct preOrderKey {
    static let coupon = "coupon"
    static let token = "token"
    static let itemOrdered = "orderItems"
    static let phoneNumber = "phone"
    static let billingAddress1 = "baddress1"
    static let billingAddress2 = "baddress2"
    static let billingCity = "bcity"
    static let billingPin = "bpin"
    static let billingState = "bstate"
    static let billingCountry = "bcountry"
    static let shipingAddress1 = "saddress1"
    static let shipingAddress2 = "saddress2"
    static let shipingCity = "scity"
    static let shipingPin = "spin"
    static let shipingState = "sstate"
    static let shipingCountry = "scountry"
}

struct preOrderResponseKey {
    static let amount = "amount"
    static let razorPaykey = "key"
    static let customerEmail = "customer_email"
    static let razorPayOrderId = "razorpay_order_id"
    static let sucessMassage = "success"
}

struct razorPayTransactionkey {
    static let token = "token"
    static let signature = "razorpay_signature"
    static let paymentId = "razorpay_payment_id"
    static let razorPayOrderId = "razorpay_order_id"
}

struct productkey{
    static let productDetails = "product_details"
    static let name = "name"
    static let productId = "id"
    static let productDescription = "description"
    static let category = "category"
    static let sellingPrice = "selling_price"
}


struct massage {
    static let moblieNumberCountErrorMassage = "Enter correct mobile number"
    static let enterMobileNumber = "Enter mobile number"
    static let duration:Double = 2
    static let wrongOtp = "OTP Entered is not valid"
    static let allFieldsRequired = "All fields are requireq!"
    static let noDataInHistory = "No Data in History!"
    static let somethingWentWrong = "Something went wrong!"
}

struct transactionKey {
    static let orderDate = "created"
    static let isSucess = "success"
    static let orderId = "id"
}
