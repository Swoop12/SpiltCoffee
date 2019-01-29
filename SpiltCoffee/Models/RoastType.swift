//
//  RoastType.swift
//  SpiltCoffee
//
//  Created by DevMountain on 1/23/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

enum RoastType: String, CaseIterable, CustomEnum{
  case light = "Light"
  case medium = "Medium"
  case dark = "Dark"
}

extension RoastType: PhotoDescribableEnum{}
