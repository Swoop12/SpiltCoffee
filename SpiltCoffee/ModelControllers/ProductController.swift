//
//  ProductController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/5/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class ProductController{
  
  //MARK: - Shared Instance
  static let shared = ProductController()
  private init(){}
  
  var objectCache = Cache<Product>()
  
  //MARK: - Create
  func createProduct(name: String, price: Double, description: String, photos: [UIImage], roaster: Roaster, productType: ProductType, completion: ((Product?) -> Void)?){
    guard productType != .coffeeBean else { completion?(nil) ; return }
    let product = Product(name: name, price: price, description: description, roasterInfo: roaster.abridgedDictionary, productType: productType)
    FirestoreClient.shared.upload(photos: photos, for: product, completion: nil)
    FirestoreClient.shared.saveToFirestore(product) { (success) in
      success ? completion?(product) : completion?(nil)
    }
  }
  
  func createCoffeeBean(name: String, price: Double, description: String, photos: [UIImage], roaster: Roaster, origin: Origin?, roastType: RoastType, completion: ((CoffeeBean?) -> Void)?){
    let bean = CoffeeBean(name: name, price: price, description: description, roasterInfo: roaster.abridgedDictionary, roastType: roastType, origin: origin)
    FirestoreClient.shared.upload(photos: photos, for: bean, completion: nil)
    FirestoreClient.shared.saveToFirestore(bean) { (success) in
      success ? completion?(bean) : completion?(nil)
    }
  }
  
  //MARK: - Read
  func fetchProducts(for category: ConstantData, completion: @escaping ([Product]?) -> Void){
    let querry = Firestore.firestore().collection("Products").whereField("productType", isEqualTo: category.name.lowercased())
    querry.getDocuments { (querrySnap, error) in
      guard let docs = querrySnap?.documents else {return}
      var products: [Product] = []
      for doc in docs {
        if doc.data()["origin"] != nil{
          if let bean = CoffeeBean(dictionary: doc.data(), id: doc.documentID){
            products.append(bean)
          }
        }else{
          if let product = Product(dictionary: doc.data(), id: doc.documentID){
            products.append(product)
          }
        }
      }
      completion(products)
    }
  }
  
  //MARK: - Update
  /**
   Updates the given product for the specified parameters
   - Parameter product: The product to be updated
   - Parameter name: The new name to be updated for the product
   - Parameter price: The new price to be updated for the product
   - Parameter description: The new description to be updated for the product
   - Parameter photos: The photos to which will be associated with the array.  This property will completely overwrite the array of photos.  If a nil value is used as a function argument the photos of the object will not be updated.
   - Parameter completion: The completion is called when the product document is finished updated, not after the photos are completed writing to storage.
   */
  func update(product: Product, name: String, price: Double, description: String, photos: [UIImage]?, productType: ProductType, completion: ((Product?) -> Void)?){
    product.name = name
    product.price = price
    product.description = description
    let dictionary: [ String : Any ] = [
      "name" : name,
      "price" : price,
      "description" : description,
      "productType" : productType.rawValue
    ]
    if let photos = photos{
      FirestoreClient.shared.upload(photos: photos, for: product, completion: nil)
    }
    product.documentReference.updateData(dictionary) { (error) in
      if let error = error{
        print("\(error.localizedDescription) \(error) in function: \(#function)")
        completion?(nil)
        return
      }
    }
    guard let photos = photos else { return }
    FirestoreClient.shared.upload(photos: photos, for: product, completion: nil)
  }
  
  func update(bean: CoffeeBean, name: String, price: Double, description: String, photos: [UIImage]?, roastType: RoastType, origin: Origin?, completion: ((CoffeeBean?) -> Void)?){
    bean.name = name
    bean.price = price
    bean.description = description
    bean.roastType = roastType
    bean.origin = origin
    bean.documentReference.updateData(bean.dictionary) { (error) in
      if let error = error{
        print("\(error.localizedDescription) \(error) in function: \(#function)")
        completion?(nil)
        return
      }else{
        completion?(bean)
      }
    }
    guard let photos = photos else { return }
    FirestoreClient.shared.upload(photos: photos, for: bean, completion: nil)
  }
  
  func favoriteBean(_ bean: CoffeeBean){
    guard let currentUser = UserController.shared.currentUser else { return }
    currentUser.favoriteBeanIDs.append(bean.uuid)
    currentUser.documentReference.updateData(
      ["favoriteBeanIDs": FieldValue.arrayUnion([bean.uuid])]
    )
    bean.favoriteCount += 1
    bean.documentReference.updateData(["favoriteCount" : bean.favoriteCount])
  }
  
  func unfavoriteBean(_ bean: CoffeeBean){
    guard let currentUser = UserController.shared.currentUser,
      let index = currentUser.favoriteBeanIDs.index(of: bean.uuid) else { return }
    currentUser.favoriteBeanIDs.remove(at: index)
    bean.favoriteCount -= 1
    currentUser.documentReference.updateData(["favoriteBeanIDs": FieldValue.arrayRemove([bean.uuid])])
    bean.documentReference.updateData(["favoriteCount": bean.favoriteCount ])
  }
  
  //MARK: - Delete
  func delete(_ product: Product, completion: ((Bool) -> Void)?) {
    objectCache.deleteObjectFor(key: product.uuid)
    UserController.shared.deleteForCurrentRoaster(product)
    FirestoreClient.shared.deleteFromFirestore(product, completion: completion)
  }
}

//MARK: - CachingController
extension ProductController: CachingController{
  typealias Cachable = Product
}
