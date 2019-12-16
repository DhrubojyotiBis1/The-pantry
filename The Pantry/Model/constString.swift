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
