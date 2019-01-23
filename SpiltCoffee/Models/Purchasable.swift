//
//  Purchasable.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/28/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

protocol Shoppable {
    var name: String { get set }
    var price: Double { get set }
    var description: String { get set }
    var photos: [UIImage]? { get set }
    var roaster: Roaster? { get }
    var type: ProductType { get }
}

enum ProductType: String{
    case coffeeBean
    case kettle
    case brewing
    case grinder
    case scale
}
