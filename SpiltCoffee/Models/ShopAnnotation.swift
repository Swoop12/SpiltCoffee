//
//  ShopAnnotation.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/30/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import Foundation
import MapKit

class ShopAnnotation: MKPointAnnotation{
    
    var shop: Shop
    
    init(shop: Shop){
        self.shop = shop
        super.init()
        self.title = shop.address
        if let coordinate = shop.coordinates{
            self.coordinate = coordinate
        }
    }
}
