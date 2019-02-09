//
//  EditProfileTableViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/7/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class EditProfileTableViewController: UITableViewController{
  
  //MARK: - IBOUTLETS
  @IBOutlet weak var locationCell: UITableViewCell!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var locationTextField: UITextField!
  @IBOutlet weak var bioTextField: UITextView!
  @IBOutlet weak var companyTextField: UITextField!
  @IBOutlet weak var becomeRoasterCell: UITableViewCell!
  
  //MARK: - Properties
  var newProfilePhoto: UIImage?
  
  //MARK: - Computed Properties
  var currentUser: Enthusiast?{
    return UserController.shared.currentUser
  }
  
  //MARK: - View LifeCycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    updateViews()
  }
  
  //MARK: - Functions
  func updateViews(){
    showAvailableViews()
    nameTextField.text = currentUser?.name
    newProfilePhoto = currentUser?.profilePicture
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(updateUser))
    if let roaster = currentUser as? Roaster{
      locationTextField.text = roaster.location
      bioTextField.text = roaster.bio
      companyTextField.text = roaster.companyName
      becomeRoasterCell.isHidden = true
    }else{
      becomeRoasterCell.isHidden = false
    }
    
  }
  
  func showAvailableViews(){
    if currentUser is Roaster{
      locationTextField.isHidden = false
      bioTextField.isHidden = false
      companyTextField.isHidden = false
    }else {
      locationTextField.isHidden = true
      bioTextField.isHidden = true
      companyTextField.isHidden = true
    }
  }
  
  func updateUser(){
    guard let name = nameTextField.text,
      let location = locationTextField.text,
      let company = companyTextField.text,
      let bio = bioTextField.text,
      let profilePicture = newProfilePhoto,
      let user = currentUser else { return }
    
    if let roaster = user as? Roaster{
      UserController.shared.update(roaster: roaster, bio: bio, companyName: company, location: location, profilePicture: profilePicture, completion: nil)
    }else if let currentUser = currentUser{
      UserController.shared.update(enthusiast: currentUser, name: name, profilePicture: profilePicture, completion: nil)
    }
    self.navigationController?.popViewController(animated: true)
  }
  
  func popToLoginScreen(){
    do{
      try Auth.auth().signOut()
      self.tabBarController?.dismiss(animated: true, completion: nil)
    } catch {
      print("There was as error in \(#function) :  \(error) \(error.localizedDescription)")
    }
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toPhotoSelector"{
      let photoSelector = segue.destination as? PhotoSelectorViewController
      photoSelector?.delegate = self
      photoSelector?.isEditingEnabled = true
      photoSelector?.photo = currentUser?.profilePicture
    } else if segue.identifier == "toBoringDetails"{
      let detailVC = segue.destination as? BoringdetailsViewController
      guard let indexPath = tableView.indexPathForSelectedRow else {return}
      print(indexPath)
      var detail: String
      switch indexPath.row{
      case 0: detail = "Terms and Conditions"
      case 1: detail = "Privacy Policy"
      default: detail = "Become a Roaster"
      }
      detailVC?.detail = detail
    }
  }
  
  //MARK: - Actions
  @IBAction func signOutButtonTapped(_ sender: Any) {
    self.presentAreYouSureAlert(title: "Are you sure you want to sign out", body: "We'll be sad to see you go") { _ in self.popToLoginScreen() }
  }
}

//MARK: - TableView Delegate & DataSource
extension EditProfileTableViewController{
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 4{
      self.performSegue(withIdentifier: "toBoringDetails", sender: self)
    }
  }
}

//MARK: - PhotoSelectorViewControllerDelegate
extension EditProfileTableViewController: PhotoSelectorViewControllerDeleate{
  func photoSelected(_ photo: UIImage) {
    self.newProfilePhoto = photo
  }
}
