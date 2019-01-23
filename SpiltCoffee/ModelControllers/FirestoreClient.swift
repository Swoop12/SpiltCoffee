//
//  FireBaseClient.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/11/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import Firebase
import UIKit

class FirestoreClient{
    
    static let shared = FirestoreClient()
    private init() {}
    //MARK: - Firestore Photo Fetches
    
    func uploadPhotos<T: FirestorePhotos>(for firestoreObject: T, completion: @escaping (Bool) -> ()){
        let photosData = firestoreObject.photosData
        
        print("uploading \(photosData.count) photos")
        let dispatchGroup = DispatchGroup()
        print("creating dispatchGroup")
        for i in 0..<photosData.count{
            dispatchGroup.enter()
            print("entering dipatch Group")
            let storageRef = Storage.storage().reference().child("\(T.CollectionName)").child("\(firestoreObject.uuid)").child("picture\(i+1)")
            storageRef.putData(photosData[i], metadata: nil) { (_, error) in
                if let error = error {
                    print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
                    completion(false)
                    dispatchGroup.leave()
                    print("leaving dispatch Group beacause of error")
                    return
                }else {
                    
                    let urlString = "\(T.CollectionName)/\(firestoreObject.uuid)/picture\(i + 1)"
                    print("photo successfully saved to storage at \(urlString)")
                    firestoreObject.photoUrlStrings.append(urlString)
                    dispatchGroup.leave()
                    print("leaving dispatch Group beacause of successful upload")
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            print("Now completing with photos")
            completion(true)
        }
    }
    
    func fetchAllFromFirestore<T: FirestoreFetchable>(with objectIDs: [String], completion: @escaping ([T]) -> ()){
        var objects: [T] = []
        let dispatchGroup = DispatchGroup()
        for id in objectIDs{
            dispatchGroup.enter()
            self.fetchFromFirestore(objectID: id) { (object: T?) in
                if let object = object{
                    print("appending object \(object)")
                    objects.append(object)
                }

                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            print("Completing with objects \(objects)")
            completion(objects)
        }
    }
    
    func fetchFromFirestore<T: FirestorePhotos>(objectID: String, completionForPost: @escaping (T?) -> (), completionForPhotos: @escaping ([UIImage]?) -> ()){
        
        let docRef = Firestore.firestore().collection(T.CollectionName).document(objectID)
        docRef.getDocument { (docSnap, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completionForPost(nil)
                completionForPhotos(nil)
                return
            }
            guard let docSnap = docSnap,
                let postDictionary = docSnap.data() else {return}
            let firestoreObject = T(dictionary: postDictionary, id: docSnap.documentID)
            completionForPost(firestoreObject)
//            self.fetchPhotosFromFirestore(for: post, completion: { (photos) in
//                completionForPhotos(photos)
//            })
        }
    }
    
    func fetchFromFirestore<T: FirestoreFetchable>(objectID: String, completion: @escaping (T?) -> ()){
        print(T.CollectionName)
        let docRef = Firestore.firestore().collection(T.CollectionName).document(objectID)
        docRef.getDocument { (docSnap, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            guard let docSnap = docSnap,
                let dictionary = docSnap.data() else {completion(nil) ; return}
//            if dictionary["postIds"] != nil{
//                let roaster = Roaster(dictionary: dictionary, id: docSnap.documentID)
//                print(roaster as Any)
//                completion(roaster as? T)
//            }
            let firestoreObject = T(dictionary: dictionary, id: docSnap.documentID)
            completion(firestoreObject)
        }
    }
    
    func fetchFirstPhotosFor<T: FirestorePhotos>(_ object: T, completion: @escaping (Bool) -> Void){
        if object.photos.first != nil { completion(true) ; return }
        
        guard let url = object.photoUrlStrings.first else { completion(false) ; return }
        print(url)
        let photoRef = Storage.storage().reference(withPath: url)
        photoRef.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(false)
                return
            }
            guard let data = data, let photo = UIImage(data: data) else { completion(false) ; return }
            object.photos = [photo]
            completion(true)
        }
    }
    
    func fetchAllObjectsWhere<T: FirestoreFetchable>(_ field: String, _ queryType: FirestoreQuery, _ value: Any, orderedBy: String?, limitedTo: Int?, completion: @escaping ([T]?) -> ()){
        
        let collectionRef = Firestore.firestore().collection(T.CollectionName)
        var query = buildQueryFor(collection: collectionRef, where: field, queryType, value: value)
        
        if let ordered = orderedBy{
            query = query.order(by: ordered, descending: true)
        }
        
        if let limit = limitedTo{
            query = query.limit(to: limit)
        }
    
        query.getDocuments { (querySnap, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            
            guard let querySnap = querySnap else {
                print("No data returned from query")
                completion(nil)
                return
            }
            
            var returnArray: [T] = []
            
            for document in querySnap.documents{
                let data = document.data()
                if let object = T(dictionary: data, id: document.documentID){
                    returnArray.append(object)
                }
            }
            
            if returnArray.isEmpty{ print("No valid Values returned") }
            completion(returnArray)
        }
    }
    
    func buildQueryFor(collection: CollectionReference, where field: String, _ queryOperation: FirestoreQuery, value: Any) -> Query{
        switch queryOperation {
        case .equals:
            return collection.whereField(field, isEqualTo: value)
        case .isLessThan:
            return collection.whereField(field, isLessThan: value)
        case .isGreaterThan:
            return collection.whereField(field, isGreaterThan: value)
        case .isLessThanOrEqualTo:
            return collection.whereField(field, isLessThanOrEqualTo: value)
        case .isGreaterThanOrEqualTo:
            return collection.whereField(field, isGreaterThanOrEqualTo: value)
        case .arrayContains:
            return collection.whereField(field, arrayContains: value)
        }
    }
    
    
    func fetchPhotoFromStorage(for path: StorageReference, completion: @escaping (UIImage?) -> ()){
        path.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
                completion(nil)
                return
            }
            guard let data = data else {completion(nil) ; return }
            let image = UIImage(data: data)
            completion(image)
        }
    }
    
    func fetchAllPhotosFromFirestore<T: FirestorePhotos>(for firestoreObject: T, completion: @escaping ([UIImage]?) -> ()){
        
        if firestoreObject.photos == nil {firestoreObject.photos = []}
        
        let dispatchGroup = DispatchGroup()
        for url in firestoreObject.photoUrlStrings{
            dispatchGroup.enter()
            let photoRef = Storage.storage().reference(withPath: url)
            photoRef.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
                    completion(nil)
                    dispatchGroup.leave()
                    return
                }
                if let data = data{
                    if let photo = UIImage(data: data){
                        firestoreObject.photos.append(photo)
                        dispatchGroup.leave()
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {
                completion(firestoreObject.photos)
            }
        }
    }
    
    func savePhotoObjectToFirestore<T: FirestorePhotos>(_ firestoreObject: T, completion: ((Bool) -> ())?){
        uploadPhotos(for: firestoreObject) { (success) in
            if success{
                let docRef = firestoreObject.documentReference
                docRef.setData(firestoreObject.dictionary) { (error) in
                    if let error = error {
                        print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
                        completion?(false)
                        return
                    }else {
                        print("Document successfully saved.")
                        completion?(true)
                    }
                }
            }else{
                print("Somthing went wrong saving those photos")
                completion?(false)
            }
        }
    }
    
    func update<T: FirestoreFetchable>(object: T, completion: ((Bool) -> Void)?){
        let docRef = Firestore.firestore().document("\(T.CollectionName)/\(object.uuid)")
        docRef.updateData(object.dictionary) { (error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion?(false)
                return
            }
            completion?(true)
        }
    }
    
    func deleteFromFirestore(_ firestoreObject: FirestoreFetchable){
        let docRef = PostController.postsCollectionRef.document(firestoreObject.uuid)
        docRef.delete { (error) in
            if let error = error {
                print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
                return
            }else {
                print("Document successfully deleted")
            }
        }
    }
    
    func saveToFirestore(_ firestoreObject: FirestoreFetchable, completion: @escaping (Bool) -> Void){
        let docRef = firestoreObject.collectionReference.document(firestoreObject.uuid)
        docRef.setData(firestoreObject.dictionary) { (error) in
            if let error = error {
                print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
                completion(false)
                return
            }else{
                completion(true)
                print("Successfully saved \(firestoreObject) with \(firestoreObject.uuid) to firestore.")
            }
        }
    }
}

enum FirestoreQuery{
    case equals
    case isLessThan
    case isGreaterThan
    case isLessThanOrEqualTo
    case isGreaterThanOrEqualTo
    case arrayContains
}
