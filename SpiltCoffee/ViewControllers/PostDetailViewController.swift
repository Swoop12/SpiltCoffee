//
//  AddPostViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/5/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
  
  //MARK: - IBOUTLET
  @IBOutlet weak var titleTextField: UITextView!
  @IBOutlet weak var bodyTextView: UITextView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var subtitleTextField: UITextField!
  @IBOutlet weak var bookmarkButton: UIButton!
  @IBOutlet weak var photoSelectorContainerView: UIView!
  
  //MARK: - Properties
  var saveBarButtonItem: UIBarButtonItem!
  var coverPhoto: [UIImage] = []
  
  //MARK: - Computed Properties
  var post: Post?{
    didSet{
      loadViewIfNeeded()
      updateViews()
      if let photos = post?.photos, photos.count > 1{
        self.coverPhoto = photos
      }
    }
  }
  
  var isBookmarked: Bool{
    guard let post = post else { return false }
    return UserController.shared.currentUser?.bookmarkIds.contains(post.uuid) ?? false
  }
  
  //MARK: - View LifeCycle Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    setDelegates()
    photoSelectorContainerView.addShadow()
    saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePost))
  }
  
  //MARK: - Functions
  func updateViews(){
    if let post = post{
      permissionGuards()
      titleTextField.text = post.title
      bodyTextView.text = post.bodyText
      updateSubtitleLabel()
      setPhotoSelectorImageView()
      dateLabel.text = post.date.asString(dateStyle: .long, timeStyle: .none)
      let bookmarkImage = isBookmarked ? #imageLiteral(resourceName: "SolidBookmark") : #imageLiteral(resourceName: "HollowBookmark")
      bookmarkButton.setImage(bookmarkImage, for: .normal)
    }else{
      dateLabel.text = Date().asString(dateStyle: .long, timeStyle: .none)
      bookmarkButton.isHidden = true
      self.navigationItem.rightBarButtonItem = saveBarButtonItem
    }
  }
  
  func updateSubtitleLabel(){
    if let subtitle = post?.subtitle, !subtitle.isEmpty{
      subtitleTextField.text = subtitle
    } else {
      subtitleTextField.isHidden = true
    }
  }
  
  func setPhotoSelectorImageView(){
    let photoSelector = self.childViewControllers[0] as? PhotoSelectorViewController
    photoSelector?.photoImageView.image = post?.photos.first
  }
  
  func permissionGuards(){
    UserController.shared.currentUser?.uuid == post?.roasterMap[PostConstants.roasterIdKey] ? setViewForEditing() : setViewForReading()
  }
  
  private func setViewForEditing() {
    titleTextField.isUserInteractionEnabled = true
    subtitleTextField.isUserInteractionEnabled = true
    bodyTextView.isEditable = true
    bookmarkButton.isHidden = true
    self.navigationItem.rightBarButtonItem = saveBarButtonItem
    self.title = "Edit Post"
  }
  
  private func setViewForReading() {
    titleTextField.isUserInteractionEnabled = false
    subtitleTextField.isUserInteractionEnabled = false
    bodyTextView.isEditable = false
    bookmarkButton.isHidden = false
    self.navigationItem.rightBarButtonItem = nil
  }
  
  private func setDelegates() {
    titleTextField.delegate = self
    subtitleTextField.delegate = self
    bodyTextView.delegate = self
  }
  
  @objc func savePost(){
    guard let title = titleTextField.text,
      !title.isEmpty,
      !bodyTextView.text.isEmpty,
      let author = UserController.shared.currentUser as? Roaster else {
        presentSimpleAlertWith(title: "Whoops Can't Create this Post", body: "Please make sure your post has a title and body.")
        return
    }
    if let post = post{
      PostController.shared.update(post: post, title: title, subtitle: subtitleTextField.text, bodyText: bodyTextView.text, photos: coverPhoto)
    }else{
      PostController.shared.createPost(title: title, subtitle: subtitleTextField.text, author: author, bodyText: bodyTextView.text, photos: coverPhoto)
    }
    self.navigationController?.popViewController(animated: true)
  }
  
  //MARK: - IBACTIONS
  @IBAction func bookmarkButtonTapped(_ sender: UIButton) {
    guard let post = post else { return }
    isBookmarked ? PostController.shared.unbookmark(post: post, completion: nil) : PostController.shared.bookmark(post: post, completion: nil)
    let bookmarkImage = isBookmarked ? #imageLiteral(resourceName: "SolidBookmark") : #imageLiteral(resourceName: "HollowBookmark")
    bookmarkButton.setImage(bookmarkImage, for: .normal)
  }
  
  @IBAction func superViewTapped(_ sender: Any) {
    bodyTextView.resignFirstResponder()
  }
}

//MARK: - PhotoSelectorViewControllerDelegate
extension PostDetailViewController: PhotoSelectorViewControllerDeleate{
  func photoSelected(_ photo: UIImage) {
    coverPhoto = [photo]
  }
}
