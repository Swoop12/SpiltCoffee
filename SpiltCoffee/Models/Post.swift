//
//  Post.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/26/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class Post: FirestorePhotos, FirestoreFetchable{
    
    static let CollectionName: String = "posts"
    
    var title: String
    var subtitle: String?
    var date: Date
    var author: Roaster?
    var bodyText: String
    var photosData: [Data] = []
    var likesCount: Int
    var uuid: String
    var photoUrlStrings: [String] = []
    var isFeatured: Bool = false
    var bookmarkCount: Int = 0
    
    
    var dictionary: [String : Any]{
        
        var dictionary: [String : Any]  = [
            PostConstants.titleKey : title,
            PostConstants.dateKey : Timestamp(date: date),
            PostConstants.bodyTextKey : bodyText,
            PostConstants.photoUrlsKey : photoUrlStrings,
            PostConstants.likesCountKey : likesCount
        ]
        
        if let subtitle = subtitle{
            dictionary[PostConstants.subtitleKey] = subtitle
        }
        if author != nil{
            dictionary[PostConstants.authorKey] = roasterMap
        }
        
        return dictionary
    }
    
    var roasterMap: [String : String]
    
    init(title: String, subtitle: String?, date: Date = Date(), author: Roaster?, bodyText: String, photos: [UIImage], uuid: String = UUID().uuidString, likesCount: Int = 0){
        self.title = title
        self.subtitle = subtitle
        self.date = date
        self.author = author
        self.bodyText = bodyText
        self.likesCount = likesCount
        self.uuid = uuid
        self.roasterMap = [PostConstants.roasterIdKey: author?.uuid ?? "Unknown",
                           PostConstants.roasterNameKey : author?.name ?? "Unknown"]
        self.photos = photos
    }
    
    required convenience init?(dictionary: [String : Any], id: String){
        
        guard let title = dictionary[PostConstants.titleKey] as? String,
            let timestamp = dictionary[PostConstants.dateKey] as? Timestamp,
            let bodyText = dictionary[PostConstants.bodyTextKey] as? String,
            let likesCount = dictionary[PostConstants.likesCountKey] as? Int,
            let photoURLStrings = dictionary[PostConstants.photoUrlsKey] as? [String] else {return nil}
        
        let subtitle = dictionary[PostConstants.subtitleKey] as? String
        let bookmarkCount = dictionary["bookmarkCount"] as? Int
        let date = timestamp.dateValue()
        let roasterMap = dictionary[PostConstants.authorKey
            ] as? [String : String]
        let isFeatured = dictionary["isFeatured"] as? Bool
        
        self.init(title: title, subtitle: subtitle, date: date, author: nil, bodyText: bodyText, photos: [], uuid: id, likesCount: likesCount)
        self.photoUrlStrings = photoURLStrings
        self.bookmarkCount = bookmarkCount ?? 0
        self.roasterMap = roasterMap ?? [:]
        self.isFeatured = isFeatured ?? false
    }
    
    func addPhotoUrl(_ url: String){
        self.photoUrlStrings.append(url)
    }
}

extension Post: Equatable{
    
    static func ==(lhs: Post, rhs: Post) -> Bool{
        return lhs.uuid == rhs.uuid
    }
}

struct PostConstants{
    static let PostCollection = "posts"
    static let titleKey = "title"
    static let subtitleKey = "subtitle"
    static let dateKey = "date"
    static let authorKey = "author"
    static let roasterIdKey = "roasterID"
    static let roasterNameKey = "authorName"
    static let bodyTextKey = "bodyText"
    static let photoUrlsKey = "photosUrls"
    static let likesCountKey = "likesCount"
}
