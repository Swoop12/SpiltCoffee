//
//  ProductType.swift
//  SpiltCoffee
//
//  Created by DevMountain on 1/23/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

enum ProductType: String, CaseIterable, CustomEnum{
  case coffeeBean
  case kettle
  case brewing
  case grinder
  case scale
}

//MARK: - PhotoDescribableEnum
//Inherits Default implementations of icon and photo from PHotoDescribably Enum
extension ProductType: PhotoDescribableEnum{}

extension ProductType{
  var description: String{
    switch self {
    case .coffeeBean:
      return "Coffee Bean"
    case .brewing:
      return "Brewing"
    case .kettle:
      return "Kettle"
    case .grinder:
      return "Grinder"
    case .scale:
      return "Scale"
    }
  }
}
