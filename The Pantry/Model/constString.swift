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
}

struct registeAndLoginPram {
    static let firstName = "first_name"
    static let lastName = "last_name"
    static let email = "email"
    static let password = "password"
    static let newPassword = "new_password"
}

struct  responceKey {
    static let firstName = "firstname"
    static let lastName = "lastname"
    static let token = "token"
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
    static let FAQ = "https://www.google.com/"
    static let privacyPolicy = "https://www.youtube.com/"
    static let aboutUs = "http://stackoverflow.com/"
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
    static let lengthOfOtp = "6"
}
