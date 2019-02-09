//
//  HomeViewController.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 8/1/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  
  //MARK: - IBOutlets
  @IBOutlet weak var favoritesCollectionView: UICollectionView!
  @IBOutlet weak var learnCollectionView: UICollectionView!
  @IBOutlet weak var roasterCollectionView: UICollectionView!
  
  //MARK: - Properties
  var favoritesCollectionViewDataSource: DataViewGenericDataSource<CoffeeBean>?
  var learnCollectionViewDataSource: DataViewGenericDataSource<Post>?
  var roasterCollectionViewDataSource: DataViewGenericDataSource<Roaster>?
  
  //MARK: - View LifeCycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchAndDisplayFavoriteBeans()
    fetchAndDisplayFeaturedPosts()
    fetchAndDisplayFeaturedRoasters()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    learnCollectionView.reloadData()
  }
  
  //MARK: - Methods
  private func fetchAndDisplayFavoriteBeans() {
    UserController.shared.getBeansForCurrentUser { (beans) in
      DispatchQueue.main.async {
        guard let beans = beans else { return }
        self.favoritesCollectionViewDataSource = DataViewGenericDataSource(dataView: self.favoritesCollectionView, dataType: DataType.coffeeBean, data: beans)
        self.favoritesCollectionViewDataSource?.delegate = self 
      }
    }
  }
  
  private func fetchAndDisplayFeaturedPosts() {
    FirestoreClient.shared.fetchAllObjectsWhere("isFeatured", .equals, true, orderedBy: nil, limitedTo: nil) { (posts: [Post]?) in
      guard let posts = posts else { return }
      DispatchQueue.main.async {
        self.learnCollectionViewDataSource = DataViewGenericDataSource(dataView: self.learnCollectionView, dataType: .post, data: posts)
        self.learnCollectionViewDataSource?.delegate = self
        self.learnCollectionView.reloadData()
      }
    }
  }
  
  private func fetchAndDisplayFeaturedRoasters() {
    FirestoreClient.shared.fetchAllObjectsWhere("isFeatured", .equals, true, orderedBy: nil, limitedTo: nil) { (roasters: [Roaster]?) in
      DispatchQueue.main.async {
        guard let roasters = roasters else { return }
        self.roasterCollectionViewDataSource = DataViewGenericDataSource(dataView: self.roasterCollectionView, dataType: .roaster, data: roasters)
        self.roasterCollectionViewDataSource?.delegate = self
      }
    }
  }
}
