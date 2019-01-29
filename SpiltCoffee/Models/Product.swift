//
//  Product.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/26/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class Product: FirestorePhotos{
  
  class var CollectionName: String { return "Products"}  
  var name: String
  var price: Double
  var description: String
  var photoUrlStrings: [String]
  var productType: ProductType
  var uuid: String
  var roasterAbridgedDictionary: [String : Any]
  
  init(name: String, price: Double, description: String, roasterInfo: [String : Any], productType: ProductType, photoUrls: [String] = [], uuid: String = UUID().uuidString){
    self.name = name
    self.price = price
    self.description = description
    self.roasterAbridgedDictionary = roasterInfo
    self.productType = productType
    self.uuid = uuid
    photoUrlStrings = photoUrls
  }
  
  required convenience init?(dictionary: [String : Any], id: String) {
    guard let name = dictionary["name"] as? String,
      let price = dictionary["price"] as? Double,
      let description = dictionary["description"] as? String,
      let photoUrlStrings = dictionary["photoUrlStrings"] as? [String],
      let roasterAbridgedDictionary = dictionary["roaster"] as? [String : Any],
      let productTypeString = dictionary["productType"] as? String, let productType = ProductType(rawValue: productTypeString) else {return nil}
    
    self.init(name: name, price: price, description: description, roasterInfo: roasterAbridgedDictionary, productType: productType, photoUrls: photoUrlStrings, uuid: id)
  }
}

extension Product: Equatable{
  static func == (lhs: Product, rhs: Product) -> Bool {
    return lhs.uuid == rhs.uuid
  }
}
