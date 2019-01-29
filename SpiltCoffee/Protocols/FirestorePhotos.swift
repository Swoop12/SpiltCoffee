//
//  ComputedPhotos.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/11/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

protocol FirestorePhotos: class, FirestoreFetchable{
  //MARK: - Properties
  var photoUrlStrings: [String] {get set}
}
