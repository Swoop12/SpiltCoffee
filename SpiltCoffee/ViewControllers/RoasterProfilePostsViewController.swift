//
//  RoasterProfilePostsViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/4/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class RoasterProfilePostsViewController: UIViewController{
  
  //MARK: - IBOutlets
  @IBOutlet weak var postsCollectionView: UICollectionView!
  
  //MARK: - Properties
  var postCollectionViewDataSource: DataViewGenericDataSource<Post>!
  var roaster: Roaster?{
    didSet{
      loadViewIfNeeded()
      updateViews()
      fetchAndDisplayPostsForRoaster()
    }
  }
  var posts: [Post]?
  
  //MARK: - View Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateViews()
  }
  
  //MARK: - Functions
  func fetchAndDisplayPostsForRoaster(){
    guard let roaster = roaster else {return}
    FirestoreClient.shared.fetchAllObjectsWhere("author.roasterID", .equals, roaster.uuid, orderedBy: nil, limitedTo: nil) { (posts: [Post]?) in
      guard let posts = posts else { return }
      DispatchQueue.main.async {
        self.posts = posts
        self.postCollectionViewDataSource = DataViewGenericDataSource(dataView: self.postsCollectionView, dataType: .post, data: posts)
        self.postCollectionViewDataSource.delegate = self
        self.postCollectionViewDataSource.roasterBio = self.roaster?.bio
        self.postCollectionViewDataSource.buttonIsHidden = !(roaster == UserController.shared.currentUser)
      }
    }
  }
  
  func updateViews(){
    if let posts = self.posts{
      postCollectionViewDataSource.sourceOfTruth = posts
    }
  }
  
  //MARK: - IBActions
  @IBAction func addPostButtonTapped(_ sender: UIButton) {
    let nilPost: Post? = nil
    self.prepareAndPerformSegue(for: .post, with: nilPost)
  }
}
