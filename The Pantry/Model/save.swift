//
//  save.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 10/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit


struct credential{
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let email = "email"
    static let token = "token"
}

public class save{
    
    func saveCredentials(withFirstName firstName:String,lastName:String,email:String,token:String){
        UserDefaults.standard.set(firstName, forKey: credential.firstName)
        UserDefaults.standard.set(lastName, forKey: credential.lastName)
        UserDefaults.standard.set(email, forKey: credential.email)
        UserDefaults.standard.set(token, forKey: credential.token)
    }
    
    func getCredentials()->[String:String]{
        var creadential = [String:String]()
        creadential[credential.firstName] =  UserDefaults.standard.string(forKey: credential.firstName)
        creadential[credential.lastName] = UserDefaults.standard.string(forKey: credential.lastName)
        creadential[credential.email] =  UserDefaults.standard.string(forKey: credential.email)
        creadential[credential.token] =  UserDefaults.standard.string(forKey: credential.token)
        return creadential
    }
}
