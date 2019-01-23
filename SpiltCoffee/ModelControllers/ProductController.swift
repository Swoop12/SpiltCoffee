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
  
  //MARK: - Create
  func createProduct(name: String, price: Double, description: String, photos: [UIImage], roaster: Roaster, productType: ProductType, completion: ((Product?) -> Void)?){
    guard productType != .coffeeBean else { completion?(nil) ; return }
    let product = Product(name: name, price: price, description: description, photos: photos, roaster: roaster, productType: productType)
    FirestoreClient.shared.savePhotoObjectToFirestore(product) { (success) in
      success ? completion?(product) : completion?(nil)
    }
  }
  
  func createCoffeeBean(name: String, price: Double, description: String, photos: [UIImage], roaster: Roaster, origin: Origin?, roastType: RoastType, completion: ((CoffeeBean?) -> Void)?){
    let bean = CoffeeBean(name: name, price: price, description: description, photos: photos, roaster: roaster, roastType: roastType, origin: origin)
    FirestoreClient.shared.savePhotoObjectToFirestore(bean) { (success) in
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
      product.photos = photos
    }
    product.documentReference.updateData(dictionary) { (error) in
      if let error = error{
        print("\(error.localizedDescription) \(error) in function: \(#function)")
        completion?(nil)
        return
      }
    }
    FirestoreClient.shared.uploadPhotos(for: product) { (success) in
      success ? completion?(product) : completion?(nil)
    }
  }
  
  func update(bean: CoffeeBean, name: String, price: Double, description: String, photos: [UIImage]?, roastType: RoastType, origin: Origin?, completion: ((CoffeeBean?) -> Void)?){
    self.update(product: bean, name: name, price: price, description: description, photos: photos, productType: .coffeeBean, completion: nil)
    bean.roastType = roastType
    bean.origin = origin
    let dictionary: [ String : Any ] = [
      "roastType" : roastType.rawValue,
      "origin" : origin?.name ?? ""
    ]
    bean.documentReference.updateData(dictionary) { (error) in
      if let error = error{
        print("\(error.localizedDescription) \(error) in function: \(#function)")
        completion?(nil)
        return
      }
      completion?(bean)
    }
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
  
}
