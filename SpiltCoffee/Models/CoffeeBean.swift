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
  
  //MARK: - Initializers
  init(name: String, price: Double, description: String, photos: [UIImage]?, roaster: Roaster?, roastType: RoastType, origin: Origin?, favoriteCount: Int = 0, uuid: String = UUID().uuidString){
    self.roastType = roastType
    self.origin = origin
    self.favoriteCount = 0
    super.init(name: name, price: price, description: description, photos: photos ?? [], roaster: roaster, productType: .coffeeBean)
  }
  
  required convenience init?(dictionary: [String : Any], id: String) {
    guard let name = dictionary["name"] as? String,
      let price = dictionary["price"] as? Double,
      let description = dictionary["description"] as? String,
      let roastTypeString = dictionary["roastType"] as? String,
      let roastType = RoastType(rawValue: roastTypeString),
      let favoriteCount = dictionary["favoriteCount"] as? Int else { return nil }
    var origin: Origin?
    if let originString = dictionary["origin"] as? String {
      origin = Origin(name: originString)
    }
    let photoUrls = dictionary["photoUrlStrings"] as? [String]
    let roasterDictionary = dictionary["roaster"] as? [String : Any]
    self.init(name: name, price: price, description: description, photos: nil, roaster: nil, roastType: roastType, origin: origin, favoriteCount: favoriteCount,uuid: id)
    self.photoUrlStrings = photoUrls ?? []
    self.roasterAbridgedDictionary = roasterDictionary
  }
}

