//
//  CachingController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 1/28/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import Foundation

protocol CachingController {
  associatedtype Cachable
  var objectCache: Cache<Cachable> { get set }
}
