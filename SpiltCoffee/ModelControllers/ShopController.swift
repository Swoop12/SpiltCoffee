//
//  ShopController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/28/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class ShopController{
    
    private init() {}
    static let shared = ShopController()
    

    
    func addShopToCurrentUserWith(address: String, email: String, phone: String, completion: @escaping (Shop?) -> Void){
        guard let currentRoaster = UserController.shared.currentUser as? Roaster else {return}
        let shop = Shop(address: address, email: email, phone: phone)
        currentRoaster.shops.append(shop)
        let shopsCollection = Firestore.firestore().collection("Users/\(currentRoaster.uuid)/Shops")
        shopsCollection.addDocument(data: shop.abridgedDictionary) { (error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }else {
                completion(shop)
            }
        }
    }
}
