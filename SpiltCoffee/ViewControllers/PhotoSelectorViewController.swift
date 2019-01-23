//
//  PhotoSelectorViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/7/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

protocol PhotoSelectorViewControllerDeleate: class {
  func photoSelected(_ photo: UIImage)
}

class PhotoSelectorViewController: UIViewController {
  
  //MARK: - IBOUTLETS
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var editPhotoButton: UIButton!
  
  //MARK: - Properties
  weak var delegate: PhotoSelectorViewControllerDeleate?
  
  //MARK: - ComputedProperties
  var photo: UIImage?{
    didSet{
      loadViewIfNeeded()
      photoImageView.image = photo
    }
  }
  
  //MARK: - View LifeCylce Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  //MARK: - Functions
  func resetView(){
    self.photoImageView.image = nil
    self.editPhotoButton.setTitle("Edit", for: .normal)
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    guard let photo = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
    picker.dismiss(animated: true) {
      self.photoImageView.image = photo
      self.editPhotoButton.setTitle("", for: .normal)
      self.delegate?.photoSelected(photo)
    }
  }
  
  //MARK: - IBActions
  @IBAction func editPhotoButtonTapped(_ sender: Any) {
    self.presentImagePickerWith(alertTitle: "Select a Photo", message: nil)
  }
  
}
