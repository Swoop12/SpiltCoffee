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
  
  //MARK: - Properties
  static let shared = FirestoreClient()
  private init() {}
  
  var objectCache = Cache<FirestoreFetchable>()
  var imageCache = Cache<UIImage>()
  
  //MARK: - Methods
    //MARK: - Generic Object Fetch
  func fetchFromFirestore<T: FirestoreFetchable>(objectID: String, completion: @escaping (T?) -> ()){
    if let object = objectCache.obejectFor(key: objectID) as? T{
      completion(object)
      return
    }
    let docRef = Firestore.firestore().collection(T.CollectionName).document(objectID)
    docRef.getDocument { (docSnap, error) in
      if let error = error{
        print("\(error.localizedDescription) \(error) in function: \(#function)")
        completion(nil)
        return
      }
      guard let docSnap = docSnap,
        let dictionary = docSnap.data() else {completion(nil) ; return}
      let firestoreObject = T(dictionary: dictionary, id: docSnap.documentID)
      completion(firestoreObject)
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
  
  //MARK: - General Object Save
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
  
    //MARK: - Photo Uploads
  private func updatePhotoReferences<T: FirestorePhotos>(for firestoreObject: T, photos: [UIImage]){
    let urls = photos.enumerated().compactMap { (index, image) -> String in
      return "\(T.CollectionName)/\(firestoreObject.uuid)/picture\(index + 1)"
    }
    firestoreObject.photoUrlStrings = urls
    firestoreObject.documentReference.updateData(["photoUrlStrings" : urls])
  }
  
  func upload(_ image: UIImage, toStoragePath path: String, completion: ((Bool) -> Void)?){
    guard let photoData = image.data else { completion?(false) ; return }
    let storageRef = Storage.storage().reference().child(path)
    self.imageCache.insert(image, key: path)
    storageRef.putData(photoData, metadata: nil) { (_, error) in
      if let error = error{
        print("\(error.localizedDescription) \(error) in function: \(#function)")
        completion?(false)
        return
      }
      completion?(true)
    }
  }
  
  func upload<T: FirestorePhotos>(photos: [UIImage], for firestoreObject: T, completion: (() -> Void)?){
    updatePhotoReferences(for: firestoreObject, photos: photos)
    let dispatchGroup = DispatchGroup()
    for (index, photo) in photos.enumerated(){
      dispatchGroup.enter()
      upload(photo, toStoragePath: "\(T.CollectionName)/\(firestoreObject.uuid)/picture\(index + 1)") { (_) in
        dispatchGroup.leave()
      }
    }
    dispatchGroup.notify(queue: .main) {
      completion?()
    }
  }
  
  //MARK: - General Photo Fetch
  func fetchPhotoFromStorage(for path: String, completion: @escaping (UIImage?) -> ()){
    if let photo = imageCache.obejectFor(key: path){
      completion(photo)
      return
    }
    let storageRef = Storage.storage().reference().child(path)
    storageRef.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
      if let error = error {
        print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
        completion(nil)
        return
      }
      guard let data = data else { completion(nil) ; return }
      if let image = UIImage(data: data){
        self.imageCache.insert(image, key: path)
        completion(image)
      }
    }
  }
  
  //MARK: - Update
  func update<T: FirestoreFetchable>(object: T, completion: ((Bool) -> Void)?){
    let docRef = Firestore.firestore().document("\(T.CollectionName)/\(object.uuid)")
    docRef.updateData(object.dictionary) { (error) in
      if let error = error{
        print("\(error.localizedDescription) \(error) in function: \(#function)")
        completion?(false)
        return
      }
      self.objectCache.insert(object, key: object.uuid)
      completion?(true)
    }
  }
  
  //MARK: - Delete
  func deleteFromFirestore(_ firestoreObject: FirestoreFetchable, completion: ((Bool) -> Void)?){
    firestoreObject.documentReference.delete { (error) in
      if let error = error {
        print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
        completion?(false)
        return
      }else {
        self.objectCache.deleteObjectFor(key: firestoreObject.uuid)
        completion?(true)
      }
    }
  }
  
  //MARK: - Custom Queries
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
}

extension FirestoreClient: CachingController{
  typealias Cachable = FirestoreFetchable
}

//MARK: - FirestoreQuery
enum FirestoreQuery{
  case equals
  case isLessThan
  case isGreaterThan
  case isLessThanOrEqualTo
  case isGreaterThanOrEqualTo
  case arrayContains
}
