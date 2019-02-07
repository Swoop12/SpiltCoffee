//
//  Roaster.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/26/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import CloudKit

class Roaster: Enthusiast, AbridgedDictionary{
    
    var productIds: [String] = [String]()
    var postIds: [String] = [String]()
    var shops: [Shop] = [Shop]()
    
    var companyName: String?
    var bio: String?
    var isFeatured: Bool = false
    var location: String?
    
    var abridgedDictionary: [String : String]{
        return [
            RoasterConstants.nameKey : name,
            RoasterConstants.roasterIDKey : uuid
        ]
    }
    
    override init(name: String, email: String, profilePictureData: Data?, uuid: String = UUID().uuidString){
        super.init(name: name, email: email, profilePictureData: profilePictureData, uuid: uuid)
    }
    
    override init(name: String, email: String, profilePicture: UIImage?, uuid: String = UUID().uuidString){
        super.init(name: name, email: email, profilePicture: profilePicture, uuid: uuid)
    }
    
    required init?(dictionary: [String : Any], id: String) {
        guard let productIds = dictionary[RoasterConstants.productIDKey] as? [String],
            let postIds = dictionary[RoasterConstants.postIDKey] as? [String] else {super.init(dictionary: dictionary, id: id) ; return nil }
        
        let companyName = dictionary[RoasterConstants.companyNameIDKey] as? String
        let bio = dictionary[RoasterConstants.bioKey] as? String
        let location = dictionary[RoasterConstants.location] as? String
      if let isFeatured = dictionary[RoasterConstants.isFeaturedKey] as? Bool{
        self.isFeatured = isFeatured
      }
        
        self.productIds = productIds
        self.postIds = postIds
        self.companyName = companyName
        self.bio = bio
        self.location = location
        super.init(dictionary: dictionary, id: id)
    }
}

struct RoasterConstants {
  static let nameKey = "name"
  static let roasterInfoKey = "roasterInfo"
  static let roasterIDKey = "roasterID"
  static let productIDKey = "productIds"
  static let postIDKey = "postIds"
  static let companyNameIDKey = "companyName"
  static let bioKey = "bio"
  static let location = "location"
  static let isFeaturedKey = "isFeatured"
}
