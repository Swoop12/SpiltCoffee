//
//  BaseUserProfileViewController.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock.
//  Copyright © 2018 DevMountain. All rights reserved.
//
import UIKit
import Firebase

class BaseUserProfileViewController: UIViewController {
  
  // MARK: - IBOutlets
  @IBOutlet weak var userHeaderView: UserProfileHeaderView!
  @IBOutlet weak var rectangleCopy4View: UIView!
  @IBOutlet weak var favoritesLabel: UILabel!
  @IBOutlet weak var rectangleCopy4TwoView: UIView!
  @IBOutlet weak var bookmarksLabel: UILabel!
  @IBOutlet weak var rectangleCopy5View: UIView!
  @IBOutlet weak var recepiesLabel: UILabel!
  @IBOutlet weak var favoritesCollectionView: UICollectionView!
  @IBOutlet weak var bookMarksCollectionView: UICollectionView!
  @IBOutlet weak var recepiesCollectionView: UICollectionView!
  
  //MARK: - Properties
  var favoriteBeansDataSource: DataViewGenericDataSource<CoffeeBean>?
  var bookMarksDataSource: DataViewGenericDataSource<Post>?
  var recepiesDataSource: DataViewGenericDataSource<Recepie>?
  var enthusiast: Enthusiast?{
    didSet{
      loadViewIfNeeded()
      updateViews()
      NotificationCenter.default.addObserver(self, selector: #selector(refreshCollectionViews), name: UserController.userUpdatedNotification, object: nil)
    }
  }
  
  //MARK: - View LifeCycle Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateViews()
    refreshCollectionViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateViews()
  }
  
  //MARK: - Functions
  @objc func refreshCollectionViews(){
    fetchAndDisplayBeansForCurrentUser()
    fetchAndDisplayPostsForCurrentUser()
    fetchAndDisplayRecepiesForCurrentUser()
  }
  
  fileprivate func fetchAndDisplayBeansForCurrentUser() {
    UserController.shared.getBeansForCurrentUser { (beans) in
      guard let beans = beans else { return }
      self.favoriteBeansDataSource = DataViewGenericDataSource(dataView: self.favoritesCollectionView, dataType: DataType.coffeeBean, data: beans)
      self.favoriteBeansDataSource?.delegate = self
    }
  }
  
  fileprivate func fetchAndDisplayPostsForCurrentUser() {
    UserController.shared.getBookmarksForCurrentUser { (posts) in
      guard let posts = posts else { return }
      self.bookMarksDataSource = DataViewGenericDataSource(dataView: self.bookMarksCollectionView, dataType: .post, data: posts)
      self.bookMarksDataSource?.delegate = self
    }
  }
  
  fileprivate func fetchAndDisplayRecepiesForCurrentUser() {
    UserController.shared.getRecepiesForCurrentUser{ (recepies) in
      guard let recepies = recepies else { return }
      self.recepiesDataSource = DataViewGenericDataSource(dataView: self.recepiesCollectionView, dataType: DataType.recepie, data: recepies)
      self.recepiesDataSource?.delegate = self
    }
  }
  
  func updateViews(){
    let currentUser = UserController.shared.currentUser
    self.title = currentUser?.name
    userHeaderView.enthusiast = currentUser
  }
}



