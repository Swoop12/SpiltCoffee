//
//  DataCell.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/2/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import Foundation

protocol DataCell {
    
    var data: AnyObject {get set}
    
    func updateViews()
}
