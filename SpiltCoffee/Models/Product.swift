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
    var photosData: [Data] = []
    
    var roasterAbridgedDictionary: [String : Any]?
    weak var roaster: Roaster?
    var productType: ProductType
    var uuid: String
    
    
    init(name: String, price: Double, description: String, photos: [UIImage], roaster: Roaster?, productType: ProductType, uuid: String = UUID().uuidString){
        self.name = name
        self.price = price
        self.description = description
        self.roaster = roaster
        self.productType = productType
        self.uuid = uuid
        photoUrlStrings = []
        self.photos = photos
    }
    
    required convenience init?(dictionary: [String : Any], id: String) {
        guard let name = dictionary["name"] as? String,
            let price = dictionary["price"] as? Double,
            let description = dictionary["description"] as? String,
            let photoUrlStrings = dictionary["photoUrlStrings"] as? [String],
            let productTypeString = dictionary["productType"] as? String, let productType = ProductType(rawValue: productTypeString) else {return nil}
        
            let roasterAbridgedDictionary = dictionary["roaster"] as? [String : Any]
        
            self.init(name: name, price: price, description: description, photos: [], roaster: nil, productType: productType, uuid: id)
            self.photoUrlStrings = photoUrlStrings
            self.roasterAbridgedDictionary = roasterAbridgedDictionary
    }
    
  
}

extension Product: Equatable{
  static func == (lhs: Product, rhs: Product) -> Bool {
    return lhs.uuid == rhs.uuid
  }
}
