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
}
