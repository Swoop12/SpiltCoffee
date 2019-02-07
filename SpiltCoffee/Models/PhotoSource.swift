//
//  PhotoSource.swift
//  SpiltCoffee
//
//  Created by DevMountain on 2/2/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

struct PhotoSource{
  var imageUrl: String?
  var photo: UIImage?
}

extension PhotoSource: Equatable {
  static func ==(lhs: PhotoSource, rhs: PhotoSource) -> Bool {
    if let lhsUrl = lhs.imageUrl, let rhsUrl = rhs.imageUrl{
      return lhsUrl == rhsUrl
    }else if let lhsImage = lhs.photo, let rhsImage = rhs.photo{
      return lhsImage == rhsImage
    }else {
      return false
    }
  }
}

