//
//  UIImage.swift
//  SpiltCoffee
//
//  Created by DevMountain on 1/28/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

extension UIImage{
  var data: Data?{
    return self.jpegData(compressionQuality: 0.25)
  }
}
