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
    
    var abridgedDictionary: [String : Any]{
        return [
            "uuid" : uuid,
            "name" : name
//            "postCount" : postCount,
//            "productCount" : productCount,
//            "followerCount" : followerCount,
//            "followingCount" : followingCount,
        ]
    }
    
    override init(name: String, email: String, profilePictureData: Data?, uuid: String = UUID().uuidString){
        super.init(name: name, email: email, profilePictureData: profilePictureData, uuid: uuid)
    }
    
    override init(name: String, email: String, profilePicture: UIImage?, uuid: String = UUID().uuidString){
        super.init(name: name, email: email, profilePicture: profilePicture, uuid: uuid)
    }
    
    required init?(dictionary: [String : Any], id: String) {
        guard let productIds = dictionary["productIds"] as? [String],
            let postIds = dictionary["postIds"] as? [String] else {super.init(dictionary: dictionary, id: id) ; return nil }
        
        let companyName = dictionary["companyName"] as? String
        let bio = dictionary["bio"] as? String
        let location = dictionary["location"] as? String
        
        self.productIds = productIds
        self.postIds = postIds
        self.companyName = companyName
        self.bio = bio
        self.location = location
        super.init(dictionary: dictionary, id: id)
    }
    
    
}

