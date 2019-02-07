//
//  RoasterProfileContentViewController.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class RoasterProfileViewController: UIViewController {
  
  // MARK: - IBOUTLETS
  @IBOutlet weak var userHeaderView: UserProfileHeaderView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var contentContainerView: UIView!
  @IBOutlet weak var shopsContainerView: UIView!
  @IBOutlet weak var productContainerView: UIView!
  @IBOutlet weak var settingsBarButtonItem: UIBarButtonItem!
  
  //MARK: - Properties
  var barButtonItemDummyARCCountHolder: UIBarButtonItem?
  var productTableViewController: AddProductTableViewController?
  var postsTableViewController: RoasterProfilePostsViewController?
  
  //MARK: - Computed Properties
  var roaster: Roaster?{
    didSet{
      loadViewIfNeeded()
      updateView()
    }
  }
  
  //MARK: - View Life Cycle Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    barButtonItemDummyARCCountHolder = settingsBarButtonItem
    segmentedControl.selectedSegmentIndex = 0
    presentTableViewFor(selectedSegementIndex: 0)
    userHeaderView.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    updateView()
  }
  
  //MARK: - Functions
  func updateView(){
    guard let roaster = roaster else {return}
    userHeaderView.enthusiast = roaster
    self.title = roaster.name
    self.navigationItem.rightBarButtonItem = roaster == UserController.shared.currentUser ? settingsBarButtonItem : nil
  }
  
  func presentTableViewFor(selectedSegementIndex: Int){
    switch selectedSegementIndex {
    case 0:
      showContentContainerView()
    case 1:
      showProductContainerView()
    case 2:
      showShopsContainerView()
    default:
      showShopsContainerView()
    }
  }
  
  private func showContentContainerView() {
    contentContainerView.isHidden = false
    shopsContainerView.isHidden = true
    productContainerView.isHidden = true
  }
  
  private func showProductContainerView() {
    contentContainerView.isHidden = true
    shopsContainerView.isHidden = true
    productContainerView.isHidden = false
  }
  
  fileprivate func showShopsContainerView() {
    contentContainerView.isHidden = true
    shopsContainerView.isHidden = false
    productContainerView.isHidden = true
  }
  
  
  //MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: self)
    if segue.identifier == "toPosts"{
      postsTableViewController = segue.destination as? RoasterProfilePostsViewController
      postsTableViewController?.roaster = self.roaster
    }else if segue.identifier == "toProducts"{
      productTableViewController = segue.destination as? AddProductTableViewController
      productTableViewController?.roaster = self.roaster
    }else if segue.identifier == "toShops"{
      let shopsTVC = segue.destination as? RoasterShopsTableViewController
      shopsTVC?.roaster = self.roaster
    }
  }
  
  // MARK: - IBActions
  @IBAction func onSegmentedControlViewValueChanged(_ sender: UISegmentedControl) {
    presentTableViewFor(selectedSegementIndex: sender.selectedSegmentIndex)
  }
}

//MARK: - UserProfileHeaderViewDelegate
extension RoasterProfileViewController: UserProfileHeaderViewDelegate{
  
  func followButtonTapped(sender: UserProfileHeaderView) {
    guard let roasertToFollow = roaster else {return}
    sender.isFollowing ? UserController.shared.unfollow(user: roasertToFollow, completion: nil) : UserController.shared.follow(user: roasertToFollow, completion: nil)
  }
  
  func reportButtonTapped(sender: UserProfileHeaderView) {
    guard let roasterToReport = roaster else { return }
    let alert = UIAlertController(title: "Block & Report This User?", message: "Please only block users for inappriate content or behavior.", preferredStyle: .alert)
    alert.addTextField { (textField) in
      textField.placeholder = "Reason for reporting"
    }
    let dimissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let blockAction = UIAlertAction(title: "Report", style: .destructive) { (_) in
      guard let reason = alert.textFields?.first?.text, !reason.isEmpty else { return }
      UserController.shared.blockAndReport(roasterToReport, for: reason)
      self.presentSimpleAlertWith(title: "User has been blocked and reported", body: "Some people's children right?")
    }
    alert.addAction(dimissAction)
    alert.addAction(blockAction)
    self.present(alert, animated: true)
  }
}
