//
//  PhotoDescribableEnum.swift
//  SpiltCoffee
//
//  Created by DevMountain on 1/23/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

protocol PhotoDescribableEnum{
  var icon: UIImage? { get }
  var photo: UIImage? { get }
  var rawValue: String { get }
}

extension PhotoDescribableEnum{
  var icon: UIImage? {
    return UIImage(named: "\(self.rawValue)Icon")
  }
  
  var photo: UIImage? {
    return UIImage(named: "\(self.rawValue)Photo")
  }
}
