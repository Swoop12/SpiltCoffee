//
//  CustomEnum.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/28/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import Foundation

protocol CustomEnum{
    var rawValue: String { get }
}

enum RoastType: String, CaseIterable, CustomEnum{
    case light = "Light"
    case medium = "Medium"
    case dark = "Dark"
}

enum ProductType: String, CaseIterable, CustomEnum{
    case coffeeBean
    case kettle
    case brewing
    case grinder
    case scale
}
