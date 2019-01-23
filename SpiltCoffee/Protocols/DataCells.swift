//
//  DataCell.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/2/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

protocol UpdatableCell{
    func updateViews()
}

class DataTableViewCell<T>: UITableViewCell, UpdatableCell {
    
    var data: T?{
        didSet{
            updateViews()
        }
    }
  
    func updateViews() {
        print("This function should be overridden")
    }
}

class DataCollectionViewCell<T>: UICollectionViewCell, UpdatableCell {
    
    var data: T?{
        didSet{
            updateViews()
        }
    }
    
    func updateViews() {
        print("This function should be overridden")
    }
}
