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
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var brewTimeTextField: UITextField!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    var photoDataSource: DataViewGenericDataSource<UIImage>!
    
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
        let photos = recipe.photos.isEmpty ? [recipe.brewMethod.image] : recipe.photos
        photoDataSource = DataViewGenericDataSource(dataView: photosCollectionView, dataType: .photo, data: photos)
    }
    
    func updateBookmarkButton(){
        let image = isBookmarked ? #imageLiteral(resourceName: "SolidBookmark") : #imageLiteral(resourceName: "HollowBookmark")
        bookmarkButton.setImage(image, for: .normal)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addPhotoButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func bookmarkButtonTapped(_ sender: Any) {
        guard let recipe = recepie else { return }
        UserController.shared.toggleBookmark(for: recipe)
        updateBookmarkButton()
    }
}
