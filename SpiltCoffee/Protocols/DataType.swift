//
//  DataType.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/2/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

enum DataType: String {
  //MARK: - Cases
  case roaster
  case enthusiast
  case post
  case shop
  case recepie
  case product
  case coffeeBean
  case origin
  case photo
  case design
  
  //MARK: - Computed Properties
  var reuseIdentifier: String{
    return "\(self.rawValue)Cell"
  }
  
  var nibName: String{
    let nibPrefix = self.rawValue.capitalizingFirstLetter()
    return "\(nibPrefix)Cell"
  }
}
