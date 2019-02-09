//
//  AddProductTableViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/4/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class AddProductTableViewController: UITableViewController {
  
  //MARK: - IBOUTLETS
  @IBOutlet weak var addProductButton: UIButton!
  @IBOutlet weak var editButtonTapped: UIBarButtonItem!
  
  //MARK: - Properties
  var beans: [CoffeeBean] = []
  var otherProducts: [Product] = []
  var products: [Product] {
    return beans + otherProducts
  }
  var productsTableViewDataSource: DataViewGenericDataSource<Product>!
  var roaster: Roaster?{
    didSet{
      loadViewIfNeeded()
      updateViews()
    }
  }
  
  //MARK: - View LifeCycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard let roaster = roaster else {return}
    fetchProducts(for: roaster)
  }
  
  //MARK: - Functions
  func fetchProducts(for roaster: Roaster){
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    FirestoreClient.shared.fetchAllObjectsWhere("roaster.uuid", .equals, roaster.uuid, orderedBy: nil, limitedTo: nil) { (products: [Product]?) in
      guard var products = products else { dispatchGroup.leave() ; return }
        self.otherProducts = products.filter{ $0.productType != .coffeeBean }
        dispatchGroup.leave()
    }
    dispatchGroup.enter()
    FirestoreClient.shared.fetchAllObjectsWhere("roaster.uuid", .equals, roaster.uuid, orderedBy: nil, limitedTo: nil) { (beans: [CoffeeBean]?) in
      guard let beans = beans else { dispatchGroup.leave() ; return }
      self.beans = beans
      dispatchGroup.leave()
    }
    dispatchGroup.notify(queue: .main) {
      self.productsTableViewDataSource = DataViewGenericDataSource(dataView: self.tableView, dataType: .product, data: self.products)
      self.tableView.delegate = self
      self.tableView.reloadData()
    }
  }
  
  func updateViews(){
    guard let roaster = roaster else { return }
    fetchProducts(for: roaster)
    addProductButton.isHidden = roaster != UserController.shared.currentUser
  }

  //MARK: - Navigation
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    prepareAndPerformSegue(for: .product, with: productsTableViewDataSource.sourceOfTruth[indexPath.row])
  }
  
  @IBAction func addProductButtonTapped(_ sender: Any) {
    let nilShoppable: Product? = nil
    self.prepareAndPerformSegue(for: .product, with: nilShoppable)
  }
}

extension AddProductTableViewController{
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
}
