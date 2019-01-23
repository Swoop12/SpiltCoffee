//
//  DataViewGenericDataSourceDelegate.swift
//  SpiltCoffee
//
//  Created by DevMountain on 1/21/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import Foundation

protocol GenericDataSourceVCDelegate: class{
  func prepareAndPerformSegue<T>(for dataType: DataType, with data: T?)
}

