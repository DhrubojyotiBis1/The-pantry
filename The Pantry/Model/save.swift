//
//  save.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 10/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit


struct saveCredential{
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let email = "email"
    static let token = "token"
    static let cartDetails = "CartDetails"
    static let phoneNumber = "phoneNumber"
}

public class save{
    
    func saveCredentials(withFirstName firstName:String,lastName:String,email:String,phoneNumber:String,token:String){
        UserDefaults.standard.set(firstName, forKey: saveCredential.firstName)
        UserDefaults.standard.set(lastName, forKey: saveCredential.lastName)
        UserDefaults.standard.set(email, forKey: saveCredential.email)
        UserDefaults.standard.set(token, forKey: saveCredential.token)
        UserDefaults.standard.set(phoneNumber, forKey: saveCredential.phoneNumber)
    }
    
    func saveCartDetais(withDetails details:[selectedProduct]){
        UserDefaults.standard.setStructArray(details, forKey: saveCredential.cartDetails)
    }
    
    func getCartDetails() -> [selectedProduct]? {
        let productAlreadyAddedToCart: [selectedProduct] = UserDefaults.standard.structArrayData(selectedProduct.self, forKey: saveCredential.cartDetails)
        
        
        return productAlreadyAddedToCart
    }
    
    func getCredentials()->[String:String]{
        var creadential = [String:String]()
        creadential[saveCredential.firstName] =  UserDefaults.standard.string(forKey: saveCredential.firstName)
        creadential[saveCredential.lastName] = UserDefaults.standard.string(forKey: saveCredential.lastName)
        creadential[saveCredential.email] =  UserDefaults.standard.string(forKey: saveCredential.email)
        creadential[saveCredential.token] =  UserDefaults.standard.string(forKey: saveCredential.token)
        creadential[saveCredential.phoneNumber] =  UserDefaults.standard.string(forKey: saveCredential.phoneNumber)
        
        return creadential
    }
    
    func removeCredentials(){
         UserDefaults.standard.removeObject(forKey: saveCredential.token)
         UserDefaults.standard.removeObject(forKey: saveCredential.firstName)
         UserDefaults.standard.removeObject(forKey: saveCredential.lastName)
         UserDefaults.standard.removeObject(forKey: saveCredential.email)
    }
    
    func removeItemAddedToCart(){
        UserDefaults.standard.removeObject(forKey: saveCredential.cartDetails)
    }
}

extension UserDefaults {
    open func setStruct<T: Codable>(_ value: T?, forKey defaultName: String){
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: defaultName)
    }
    
    open func structData<T>(_ type: T.Type, forKey defaultName: String) -> T? where T : Decodable {
        guard let encodedData = data(forKey: defaultName) else {
            return nil
        }
        
        return try! JSONDecoder().decode(type, from: encodedData)
    }
    
    open func setStructArray<T: Codable>(_ value: [T], forKey defaultName: String){
        let data = value.map { try? JSONEncoder().encode($0) }
        
        set(data, forKey: defaultName)
    }
    
    open func structArrayData<T>(_ type: T.Type, forKey defaultName: String) -> [T] where T : Decodable {
        guard let encodedData = array(forKey: defaultName) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(type, from: $0) }
    }
}
