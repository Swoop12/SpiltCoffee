//
//  Post.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/26/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class Post: FirestoreFetchable{
  
  //MARK: - Properties
  static let CollectionName: String = "posts"
  var title: String
  var subtitle: String?
  var date: Date
  var roasterInfo: [String : String]
  var bodyText: String
  var likesCount: Int
  var uuid: String
  var isFeatured: Bool
  var bookmarkCount: Int
  
  var thumbnailUrl: String{
    return "\(Post.CollectionName)/\(uuid).jpg"
  }
  
  //MARK: - Initializers
  init(title: String, subtitle: String?, date: Date = Date(), roasterInfo: [String : String], bodyText: String, uuid: String = UUID().uuidString, likesCount: Int = 0, isFeatured: Bool = false, bookmarkCount: Int = 0){
    self.title = title
    self.subtitle = subtitle
    self.date = date
    self.roasterInfo = roasterInfo
    self.bodyText = bodyText
    self.likesCount = likesCount
    self.uuid = uuid
    self.isFeatured = isFeatured
    self.bookmarkCount = bookmarkCount
  }
  
  required convenience init?(dictionary: [String : Any], id: String){
    guard let title = dictionary[PostConstants.titleKey] as? String,
      let timestamp = dictionary[PostConstants.dateKey] as? Timestamp,
      let bodyText = dictionary[PostConstants.bodyTextKey] as? String,
      let likesCount = dictionary[PostConstants.likesCountKey] as? Int,
      let roasterInfo = dictionary[RoasterConstants.roasterInfoKey] as? [String : String] ,
      let bookmarkCount = dictionary[PostConstants.bookmarkCountKey] as? Int,
      let isFeatured = dictionary[PostConstants.isFeaturedKey] as? Bool else { return nil }
    
    let date = timestamp.dateValue()
    let subtitle = dictionary[PostConstants.subtitleKey] as? String
    
    self.init(title: title, subtitle: subtitle, date: date, roasterInfo: roasterInfo, bodyText: bodyText, uuid: id, likesCount: likesCount, isFeatured: isFeatured, bookmarkCount: bookmarkCount)
  }
}

//MARK: - Equatable
extension Post: Equatable{
  static func ==(lhs: Post, rhs: Post) -> Bool{
    return lhs.uuid == rhs.uuid
  }
}

//MARK: - Post Constants
struct PostConstants{
  static let PostCollection = "posts"
  static let titleKey = "title"
  static let subtitleKey = "subtitle"
  static let dateKey = "date"
  static let bodyTextKey = "bodyText"
  static let coverPhotoUrlKey = "coverPhotoUrl"
  static let likesCountKey = "likesCount"
  static let bookmarkCountKey = "bookmarkCount"
  static let isFeaturedKey = "isFeatured"
}
