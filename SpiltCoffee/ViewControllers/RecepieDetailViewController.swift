//
//  RecepieDetailViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/17/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class RecepieDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var brewTimeTextField: UITextField!
    @IBOutlet weak var bookmarkButton: UIButton!
  var photoPagerViewController: PhotoPagerViewContoller?
  
    var recepie: Recepie?{
        didSet{
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    var isBookmarked: Bool{
        guard let recipe = recepie else {return false}
        return UserController.shared.currentUser?.favoriteRecepieIds.contains(recipe.uuid) ?? false
    }
    
    func updateViews(){
        guard let recipe = recepie else { return }
        titleLabel.text = recepie?.title
        self.title = recepie?.title
        ingredientsTextView.text = recepie?.instructions
        updateBookmarkButton()
        brewTimeTextField.text = "\(recepie?.brewTimeInMinutes ?? 0) minutes"
      
//      let photos = recipe.photosData.isEmpty ? [recipe.brewMethod.image] : recipe.photos
//        photoDataSource = DataViewGenericDataSource(dataView: photosCollectionView, dataType: .photo, data: photos)
    }
    
    func updateBookmarkButton(){
        let image = isBookmarked ? #imageLiteral(resourceName: "SolidBookmark") : #imageLiteral(resourceName: "HollowBookmark")
        bookmarkButton.setImage(image, for: .normal)
    }
  
  //MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    if segue.identifier == "toPhotoPager"{
      guard let recepie = recepie else { return }
      photoPagerViewController = (segue.destination as! PhotoPagerViewContoller)
      photoPagerViewController?.isEditingEnabled = false
      photoPagerViewController?.setPager(for: [recepie.brewMethod.image])
    }
  }
    
    @IBAction func bookmarkButtonTapped(_ sender: Any) {
        guard let recipe = recepie else { return }
        UserController.shared.toggleBookmark(for: recipe)
        updateBookmarkButton()
    }
}
