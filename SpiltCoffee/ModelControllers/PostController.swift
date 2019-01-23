//
//  PostController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/5/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class PostController {
    
    static let shared = PostController()
    private init(){}
    
    static let postsCollectionRef = Firestore.firestore().collection(PostConstants.PostCollection)
    
    var posts: [Post] = []
    
    //CRUD
    @discardableResult
    func createPost(title: String, subtitle: String?, author: Roaster, bodyText: String, photos: [UIImage]) -> Post{
        let post = Post(title: title, subtitle: subtitle, author: author, bodyText: bodyText, photos: photos)
        posts.append(post)
        saveToFirestore(post: post)
        author.postIds.append(post.uuid)
        author.documentReference.updateData(["postIds" : FieldValue.arrayUnion([post.uuid])])
        return post
    }
    
    @discardableResult
    func update(post: Post, title: String, subtitle: String?, bodyText: String, photos: [UIImage]) -> Post{
        post.title = title
        post.subtitle = subtitle
        post.bodyText = bodyText
        post.photos = photos
        post.documentReference.updateData([
            PostConstants.titleKey : title,
            PostConstants.subtitleKey : subtitle ?? "",
            PostConstants.bodyTextKey : bodyText
            ])
        FirestoreClient.shared.uploadPhotos(for: post) { (_) in
        }
        return post
    }
    
    func bookmark(post: Post, completion: ((Bool)->())?){
        
        guard let currentUser = UserController.shared.currentUser else { return }
        currentUser.bookmarkIds.append(post.uuid)
        post.bookmarkCount += 1
        Firestore.firestore().document("Users/\(currentUser.uuid)").updateData(["bookmarkIds" : FieldValue.arrayUnion([post.uuid])]) { (error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion?(false)
                return
            }else{
                completion?(true)
            }
        }
        
        Firestore.firestore().document("posts/\(post.uuid)").updateData(["bookmarkCount" : post.bookmarkCount])
    }
    
    func unbookmark(post: Post, completion: ((Bool)->())?){
        guard let currentUser = UserController.shared.currentUser,
            let bookmarkIndex = currentUser.bookmarkIds.index(of: post.uuid)  else { return }
        currentUser.bookmarkIds.remove(at: bookmarkIndex)
        post.bookmarkCount -= 1
        
        Firestore.firestore().document("Users/\(currentUser.uuid)").updateData(["bookmarkIds" : FieldValue.arrayRemove([post.uuid])]) { (error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion?(false)
                return
            }else{
                completion?(true)
            }
        }
        
        Firestore.firestore().document("posts/\(post.uuid)").updateData(["bookmarkCount" : post.bookmarkCount])
    }
    
    func deletePost(post: Post) -> Post?{
        guard let index = self.posts.index(of: post) else {return nil}
        deleteFromFirestore(post: post)
        return posts.remove(at: index)
    }
    
    
    //MARK: - Firebase
    
//    func uploadPhotos(post: Post, completion: @escaping (Bool) -> ()){
//        let photosData = post.photosData
//        let dispatchGroup = DispatchGroup()
//        for i in 0..<photosData.count{
//            dispatchGroup.enter()
//            let storageRef = Storage.storage().reference().child("\(PostConstants.PostCollection)").child("\(post.uuid)").child("picture\(i+1)")
//            storageRef.putData(photosData[i], metadata: nil) { (_, error) in
//                if let error = error {
//                    print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
//                    completion(false)
//                    dispatchGroup.leave()
//                    return
//                }else {
//                    storageRef.downloadURL(completion: { (url, error) in
//                        if let error = error {
//                            print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
//                            completion(false)
//                            dispatchGroup.leave()
//                            return
//                        }
//                        guard let urlString = url?.absoluteString else {return}
//                        post.photoUrlStrings.append(urlString)
//                        dispatchGroup.leave()
//
//                    })
//                }
//            }
//        }
//        dispatchGroup.notify(queue: .main) {
//            completion(true)
//        }
//    }
//
    func fetchFromFirestore(postID: String, completionForPost: @escaping (Post?) -> (), completionForPhotos: @escaping ([UIImage]?) -> ()){
        
        let docRef = PostController.postsCollectionRef.document(postID)
        docRef.getDocument { (docSnap, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completionForPost(nil)
                completionForPhotos(nil)
                return
            }
            guard let docSnap = docSnap,
                let postDictionary = docSnap.data() else {return}
            guard let post = Post(dictionary: postDictionary, id: docSnap.documentID) else {return}
            completionForPost(post)
            self.fetchPhotosFromFirestore(for: post, completion: { (photos) in
                completionForPhotos(photos)
            })
        }
    }
    
    func fetchPhotosFromFirestore(for post: Post, completion: @escaping ([UIImage]?) -> ()){
        
        let dispatchGroup = DispatchGroup()
        for url in post.photoUrlStrings{
            dispatchGroup.enter()
            let photoRef = Storage.storage().reference(forURL: url)
            photoRef.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
                    completion(nil)
                    return
                }
                if let data = data{
                    if let photo = UIImage(data: data){
                        post.photos.append(photo)
                        dispatchGroup.leave()
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {
                completion(post.photos)
            }
        }
    }
    
    func saveToFirestore(post: Post){
        FirestoreClient.shared.uploadPhotos(for: post, completion: { (success) in
            if success{
                let docRef = PostController.postsCollectionRef.document(post.uuid)
                docRef.setData(post.dictionary) { (error) in
                    if let error = error {
                        print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
                        return
                    }else {
                        print("Document successfully saved.  Now attempting to upload photos")
                    }
                }
            }else{
                print("Somthing went wrong fetching those photos")
            }
        })
    }
    
    func deleteFromFirestore(post: Post){
        let docRef = PostController.postsCollectionRef.document(post.uuid)
        docRef.delete { (error) in
            if let error = error {
                print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
                return
            }else {
                print("Document successfully deleted")
            }
        }
    }
}
