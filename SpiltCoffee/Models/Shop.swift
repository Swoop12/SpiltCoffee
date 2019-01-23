
//
//  Locations.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/26/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import CoreLocation

class Shop: AbridgedDictionary, Equatable{
    
    
    convenience init?(dictionary: [String : Any]) {
        guard let address = dictionary["address"] as? String,
            let phone = dictionary["phone"] as? String,
            let email = dictionary["email"] as? String else {return nil}
        self.init(address: address, email: email, phone: phone)
    }
    
    var address: String
    var email: String
    var phone: String
    var coordinates: CLLocationCoordinate2D?
    
    var abridgedDictionary: [String : Any]{
        return ["address" : address,
         "email" : email,
         "phone" : phone]
    }
    
    init(address: String, email: String, phone: String){
        self.address = address
        self.email = email
        self.phone = phone
        getCooridnates(completion: nil)
    }
    
    func getCooridnates(completion: ((CLLocationCoordinate2D?) -> Void)?){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion?(nil)
                return
            }
            self.coordinates = placemarks?.first?.location?.coordinate
            completion?(self.coordinates)
        }
    }
    
    static func == (lhs: Shop, rhs: Shop) -> Bool {
        return lhs.address == rhs.address
    }
}
