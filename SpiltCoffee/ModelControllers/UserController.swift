//
//  EnthusiastController.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/26/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class UserController: NSObject {

    static let shared = UserController()
    static let userUpdatedNotification = Notification.Name(rawValue: "User was updated.")
    
    var currentUser: Enthusiast?{
        didSet{
            addListenerForCurrentUser()
        }
    }
    var listener: ListenerRegistration?
    
    var locationManager =  CLLocationManager()
    var currentLocation: CLLocation?
    
    func createNewUser(name: String, email: String, profilePicture: UIImage?, uuid: String, completion: @escaping (Bool) -> () ) -> Enthusiast{
        var data: Data?
        if let profilePicture = profilePicture{
            data = UIImageJPEGRepresentation(profilePicture, 0.3)
        }
        
        let newUser = Enthusiast(name: name, email: email, profilePictureData: data, uuid: uuid)
        FirestoreClient.shared.saveToFirestore(newUser, completion: completion)
        saveProfilePictureForUser(newUser) { (success) in
            print("Profile Picture save?  👻 \(success)")
        }
        return newUser
    }
    
    func fetchFullUser(id: String, completion: @escaping (Enthusiast?) -> ()){
        
        let docRef = Firestore.firestore().collection(Enthusiast.CollectionName).document(id)
        docRef.getDocument { (docSnap, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            guard let docSnap = docSnap,
                let dictionary = docSnap.data() else {completion(nil) ; return}
            var user: Enthusiast?
            if dictionary["postIds"] != nil{
                user = Roaster(dictionary: dictionary, id: docSnap.documentID)
            }else{
                user = Enthusiast(dictionary: dictionary, id: docSnap.documentID)
            }
            
            guard let fectchedUser = user else {
                print("No user intialized")
                completion(nil)
                return
            }
            self.fetchProfilePicture(for: fectchedUser, completion: { (_) in
                completion(user)
            })
        }
    }
    
    func fetchProfilePicture(for user: Enthusiast, completion: @escaping (UIImage?) -> Void){
        
        guard user.profilePicture == nil else { completion(user.profilePicture) ; return }
        let profileReference = Storage.storage().reference(withPath: user.profilePictureUrl)
        FirestoreClient.shared.fetchPhotoFromStorage(for: profileReference, completion: { (photo) in
            guard let photo = photo else {
                print("No profile picture returned")
                completion(nil)
                return
            }
            user.profilePicture = photo
            completion(photo)
        })
    }
    
    func saveProfilePictureForUser(_ user: Enthusiast, completion: ((Bool) -> ())?){
        let storageRef = Storage.storage().reference().child(Enthusiast.CollectionName).child(user.uuid)
        guard let data = user.profilePictureData else {completion?(false) ; return}
        storageRef.putData(data, metadata: nil) { (nil, error) in
            if let error = error {
                print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
                completion?(false)
                return
            }
            completion?(true)
        }
    }
    
    func fetchCurrentUser(completion: ((Enthusiast?) -> Void)?){
        guard let firebaseUser = Auth.auth().currentUser else {return}
        FirestoreClient.shared.fetchFromFirestore(objectID: firebaseUser.uid) { (enthusiast: Enthusiast?) in
            self.currentUser = enthusiast
            completion?(self.currentUser)
        }
    }
    
    func getBeansForCurrentUser(completion: @escaping ([CoffeeBean]?) -> ()){
        guard let beanIds = currentUser?.favoriteBeanIDs else {completion(nil) ; return}
        FirestoreClient.shared.fetchAllFromFirestore(with: beanIds, completion: completion)
    }
    
    func getBookmarksForCurrentUser(completion: @escaping ([Post]?) -> ()){
        guard let postIds = currentUser?.bookmarkIds else {completion(nil) ; return}
        FirestoreClient.shared.fetchAllFromFirestore(with: postIds, completion: completion)
    }
    
    func getRoastersForCurrentUser(completion: @escaping ([Roaster]?) -> ()){
        guard let roasterIds = currentUser?.followingIds else {completion(nil) ; return}
        FirestoreClient.shared.fetchAllFromFirestore(with: roasterIds, completion: completion)
    }
    
    func getRecepiesForCurrentUser(completion: @escaping ([Recepie]?) -> ()){
        guard let recepieIds = currentUser?.favoriteRecepieIds else {completion(nil) ; return}
        FirestoreClient.shared.fetchAllFromFirestore(with: recepieIds, completion: completion)
    }
    
    func getShops(for roaster: Roaster, completion: @escaping ([Shop]?) -> Void){
        let shopsCollection = Firestore.firestore().collection("Users/\(roaster.uuid)/Shops")
        shopsCollection.getDocuments { (querySnap, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            guard let querySnap = querySnap else { return }
            let shops = querySnap.documents.compactMap{ Shop(dictionary: $0.data())}
            roaster.shops = shops
            completion(shops)
        }
    }
    
    func follow(user: Enthusiast, completion: ((Bool) -> Void)?){
        guard let currentUser = currentUser else { return }
        currentUser.followingIds.append(user.uuid)
        user.followerIds.append(currentUser.uuid)
        
        
        Firestore.firestore().document("Users/\(currentUser.uuid)").updateData([
            "followingIds": FieldValue.arrayUnion([user.uuid])
        ]) { (error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion?(false)
                return
            }else{
                completion?(true)
            }
        }
        Firestore.firestore().document("Users/\(user.uuid)").updateData(["followerIds": FieldValue.arrayUnion([currentUser.uuid])])
    }
    
    func unfollow(user: Enthusiast, completion: ((Bool)->Void)?){
        guard let currentUser = currentUser else { return }
        
        if let currentUserIndex = currentUser.followingIds.index(of: user.uuid){
            currentUser.followingIds.remove(at: currentUserIndex)
        }
        if let unfollowedIndex = user.followerIds.index(of: currentUser.uuid){
            user.followerIds.remove(at: unfollowedIndex)
        }
        
        
        Firestore.firestore().document("Users/\(currentUser.uuid)").updateData([
            "followingIds": FieldValue.arrayRemove([user.uuid])
        ]) { (error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion?(false)
                return
            }else{
                completion?(true)
            }
        }
        Firestore.firestore().document("Users/\(user.uuid)").updateData(["followerIds": FieldValue.arrayRemove([currentUser.uuid])])
    }
    
    func blockAndReport(_ user: Enthusiast, for reason: String){
        guard let currentUser = currentUser else { return }
        
        if let currentUserIndex = currentUser.followerIds.index(of: user.uuid){
            currentUser.followerIds.remove(at: currentUserIndex)
        }
        
        if let blockedUserIndex = user.followingIds.index(of: currentUser.uuid){
            user.followingIds.remove(at: blockedUserIndex)
        }
        
        
        Firestore.firestore().document("Users/\(user.uuid)").updateData(["followingIds": FieldValue.arrayRemove([currentUser.uuid])])
        
        Firestore.firestore().document("Users/\(currentUser.uuid)").updateData(["followerIds" : FieldValue.arrayRemove([user.uuid])])
        
        Firestore.firestore().collection("Reports/Users/\(user.uuid)").addDocument(data: [
            "Reporter" : currentUser.uuid,
            "Reason" : reason
            ])
    }
    
    func update(roaster: Roaster, bio: String, companyName: String, location: String, profilePicture: UIImage?, completion: ((Bool) -> Void)?){
        roaster.bio = bio
        roaster.companyName = companyName
        roaster.profilePicture = profilePicture
        roaster.location = location
        FirestoreClient.shared.update(object: roaster, completion: completion)
        saveProfilePictureForUser(roaster, completion: nil)
    }
    
    func update(enthusiast: Enthusiast, name: String, profilePicture: UIImage?, completion: ((Bool)->Void)?){
        enthusiast.name = name
        enthusiast.profilePicture = profilePicture
        FirestoreClient.shared.update(object: enthusiast, completion: completion)
        saveProfilePictureForUser(enthusiast, completion: nil)
    }
    
    func toggleBookmark(for recipe: Recepie){
        guard let currentUser = currentUser else { return }
        if currentUser.favoriteRecepieIds.contains(recipe.uuid){
            guard let recipeIndex = currentUser.favoriteRecepieIds.index(of: recipe.uuid) else { return }
            currentUser.favoriteRecepieIds.remove(at: recipeIndex)
        }else {
            currentUser.favoriteRecepieIds.append(recipe.uuid)
        }
        
        currentUser.collectionReference.document("\(currentUser.uuid)").updateData(
            ["favoriteRecepieIds" : currentUser.favoriteRecepieIds]
        )
    }
    
    func addListenerForCurrentUser(){
        guard let currentUser = currentUser else { listener?.remove() ; return }
        listener = Firestore.firestore().document("Users/\(currentUser.uuid)").addSnapshotListener { (_, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                return
            }else {
                NotificationCenter.default.post(name: UserController.userUpdatedNotification, object: self)
            }
        }
    }
}

extension UserController: CLLocationManagerDelegate{
    
    func requestLocation(){
        locationManager.requestWhenInUseAuthorization()
        if  CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }
}
