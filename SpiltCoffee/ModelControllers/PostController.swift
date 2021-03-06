//
//  PostController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/5/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class PostController {
  
  //MARK: - Properties
  static let shared = PostController()
  private init(){}
  
  var objectCache = Cache<Post>()
  
  //MARK: - CRUD Methods
  func createPost(title: String, subtitle: String?, author: Roaster, bodyText: String, coverPhoto: UIImage?, completion: ((Post?) -> Void)?){
    let post = Post(title: title, subtitle: subtitle, roasterInfo: author.abridgedDictionary, bodyText: bodyText)
    author.postIds.append(post.uuid)
    FirestoreClient.shared.update(object: author, completion: nil)
    if let coverPhoto = coverPhoto{
      saveCoverPhoto(for: post, image: coverPhoto) { (_) in }
    }
    FirestoreClient.shared.saveToFirestore(post) { (success) in
      success ? completion?(post) : completion?(nil)
    }
    objectCache.insert(post, key: post.uuid)
  }
  
  func update(post: Post, title: String, subtitle: String?, bodyText: String, coverPhoto: UIImage?, completion: ((Post?) -> Void)?){
    post.title = title
    post.subtitle = subtitle
    post.bodyText = bodyText
    FirestoreClient.shared.update(object: post, completion: nil)
    guard let coverPhoto = coverPhoto else { completion?(nil) ; return }
    saveCoverPhoto(for: post, image: coverPhoto) { (success) in
      success ? completion?(post) : completion?(nil)
    }
  }
  
  func saveCoverPhoto(for post: Post, image: UIImage, completion: @escaping (Bool) -> Void){
    let path = "\(Post.CollectionName)/\(post.uuid).jpg"
    FirestoreClient.shared.upload(image, toStoragePath: path, completion: completion)
  }
  
  func bookmark(post: Post, completion: ((Bool) -> Void)?){
    guard let currentUser = UserController.shared.currentUser else { completion?(false) ; return }
    currentUser.bookmarkIds.append(post.uuid)
    post.bookmarkCount += 1
    FirestoreClient.shared.update(object: currentUser, completion: nil)
    FirestoreClient.shared.update(object: post, completion: completion)
  }
  
  func unbookmark(post: Post, completion: ((Bool) -> Void)?){
    guard let currentUser = UserController.shared.currentUser,
      let bookmarkIndex = currentUser.bookmarkIds.index(of: post.uuid)  else { return }
    currentUser.bookmarkIds.remove(at: bookmarkIndex)
    post.bookmarkCount -= 1
    FirestoreClient.shared.update(object: currentUser, completion: nil)
    FirestoreClient.shared.update(object: post, completion: completion)
  }
  
  func deletePost(post: Post, completion: ((Bool) -> Void)?){
    objectCache.deleteObjectFor(key: post.uuid)
    UserController.shared.deleteForCurrentRoaster(post)
    FirestoreClient.shared.deleteFromFirestore(post, completion: completion)
  }
}

extension PostController: CachingController{
  typealias Cachable = Post
}
