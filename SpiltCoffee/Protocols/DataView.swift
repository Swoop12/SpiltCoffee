//
//  DataView.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/2/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

protocol DataView{
    func reloadData()
    func registerNib(nibName: String, cellIdentifier: String)
}

extension UITableView: DataView{
    public func registerNib(nibName: String, cellIdentifier: String) {
        self.register(UINib(nibName: nibName, bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
    }
}
extension UICollectionView: DataView{
    public func registerNib(nibName: String, cellIdentifier: String) {
        self.register(UINib(nibName: nibName, bundle: Bundle.main), forCellWithReuseIdentifier: cellIdentifier)
    }
}
