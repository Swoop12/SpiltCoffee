//
//  Enthusiast.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/26/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class Enthusiast: FirestoreFetchable{
    
    static let CollectionName: String = "Users"
    
    //CloudKit Properties
    var profilePictureData: Data?
    var profilePictureUrl: String {
        return "\(Enthusiast.CollectionName)/\(self.uuid)"
    }

    
    //User Properties
    let uuid: String
    var name: String
    var email: String
    
    var followerIds: [String] = []
    var followingIds: [String] = []
    
    var bookmarkIds: [String] = []
    var favoriteRecepieIds: [String] = []
    var favoriteBeanIDs: [String] = []
    
    var profilePicture: UIImage? {
        get{
            guard let data = profilePictureData,
                let image = UIImage(data: data) else { return nil }
            return image
        }
        set {
            guard let image =  newValue,
                let data = image.jpegData(compressionQuality: 0.5) else {return}
            profilePictureData = data
        }
    }
    
    init(name: String, email: String, profilePictureData: Data?, uuid: String = UUID().uuidString){
        self.name = name
        self.email = email
        self.profilePictureData = profilePictureData
        self.uuid = uuid
    }

    
    init(name: String, email: String, profilePicture: UIImage?, uuid: String = UUID().uuidString){
        self.name = name
        self.email = email
        self.uuid = uuid
        if let profilePicture = profilePicture{
            profilePictureData = profilePicture.jpegData(compressionQuality: 0.3)
        }
    }
    
    required init?(dictionary: [String : Any], id: String) {
        guard let name = dictionary["name"] as? String,
            let email = dictionary["email"] as? String else {return nil}
        
        let bookmarkIds = dictionary["bookmarkIds"] as? [String]
        let followerIds = dictionary["followerIds"] as? [String]
        let followingIds = dictionary["followingIds"] as? [String]
        let beanIds = dictionary["favoriteBeanIDs"] as? [String]
        let favoriteRecepieIds = dictionary["favoriteRecepieIds"] as? [String]
        let recipeIds = dictionary["favoriteRecepieIds"] as? [String]
        
        self.name = name
        self.email = email
        self.uuid = id
        self.followerIds = followerIds ?? []
        self.followingIds = followingIds ?? []
        self.favoriteRecepieIds = favoriteRecepieIds ?? []
        self.bookmarkIds = bookmarkIds ?? []
        self.favoriteBeanIDs = beanIds ?? []
        self.favoriteRecepieIds = recipeIds ?? []
    }
}

extension Enthusiast: Equatable{
    
    static func ==(lhs: Enthusiast, rhs: Enthusiast) -> Bool{
        return lhs.uuid == rhs.uuid
    }
}
