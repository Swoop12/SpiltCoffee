//
//  CoffeeBean.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/28/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class CoffeeBean: Product{
  
  //MARK: - Properties
  var roastType: RoastType
  var origin: Origin?
  var favoriteCount: Int
  
  var dictionary: [String : Any]{
    var dict: [String : Any] = [
      "name" : name,
      "price" : price,
      "description" : description,
      "photoUrlStrings" : photoUrlStrings,
      "roastType" : roastType.rawValue,
      "favoriteCount" : favoriteCount,
      "roaster" : roasterAbridgedDictionary
    ]
    if let origin = origin{
      dict["origin"] = origin.name
    }
    return dict
  }
  
  //MARK: - Initializers
  init(name: String, price: Double, description: String, roasterInfo: [String : String], roastType: RoastType, origin: Origin?, favoriteCount: Int = 0, uuid: String = UUID().uuidString){
    self.roastType = roastType
    self.origin = origin
    self.favoriteCount = 0
    super.init(name: name, price: price, description: description, roasterInfo: roasterInfo, productType: .coffeeBean, uuid: uuid)
  }
  
  required convenience init?(dictionary: [String : Any], id: String) {
    guard let name = dictionary["name"] as? String,
      let price = dictionary["price"] as? Double,
      let description = dictionary["description"] as? String,
      let roastTypeString = dictionary["roastType"] as? String,
      let roastType = RoastType(rawValue: roastTypeString),
      let roasterDictionary = dictionary["roaster"] as? [String : String],
      let favoriteCount = dictionary["favoriteCount"] as? Int else { return nil }
    var origin: Origin?
    if let originString = dictionary["origin"] as? String {
      origin = Origin(name: originString)
    }
    let photoUrls = dictionary["photoUrlStrings"] as? [String]
    
    self.init(name: name, price: price, description: description, roasterInfo: roasterDictionary, roastType: roastType, origin: origin, favoriteCount: favoriteCount, uuid: id)
    self.photoUrlStrings = photoUrls ?? []
  }
}

