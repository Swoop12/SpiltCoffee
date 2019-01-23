//
//  ProductsTableViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/4/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController {
  
  //MARK: - Properties
  var productTableViewDataSource: DataViewGenericDataSource<Product>!
  var category: ConstantData?{
    didSet{
      loadViewIfNeeded()
      fetchAndDisplayProducts()
    }
  }
  
  //MARK: - View Life Cycle Functions
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  //MARK: - Functions
  func fetchAndDisplayProducts(){
    guard let category = category else { return }
    self.title = category.name
    ProductController.shared.fetchProducts(for: category) { (products) in
      guard let products = products else { return }
      print(products)
      self.productTableViewDataSource = DataViewGenericDataSource(dataView: self.tableView, dataType: .product, data: products)
      self.productTableViewDataSource.delegate = self
      self.productTableViewDataSource.constantRowHeight = 150
      self.tableView.reloadData()
    }
  }
}
