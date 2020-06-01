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
  @IBOutlet weak var deletePostButton: UIButton!
  
  //MARK: - Properties
  var saveBarButtonItem: UIBarButtonItem!
  var coverPhoto: UIImage?
  var photoSelectorViewController: PhotoSelectorViewController!
  
  //MARK: - Computed Properties
  var post: Post?{
    didSet{
      loadViewIfNeeded()
      updateViews()
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
    let photoSelector = self.children[0] as? PhotoSelectorViewController
    photoSelector?.imageUrlString = post?.thumbnailUrl
  }
  
  func permissionGuards(){
    UserController.shared.currentUser?.uuid == post?.roasterInfo[RoasterConstants.roasterIDKey] ? setViewForEditing() : setViewForReading()
  }
  
  private func setViewForEditing() {
    titleTextField.isUserInteractionEnabled = true
    subtitleTextField.isUserInteractionEnabled = true
    bodyTextView.isEditable = true
    bookmarkButton.isHidden = true
    deletePostButton.isHidden = false
    self.navigationItem.rightBarButtonItem = saveBarButtonItem
    self.title = "Edit Post"
  }
  
  private func setViewForReading() {
    titleTextField.isUserInteractionEnabled = false
    subtitleTextField.isUserInteractionEnabled = false
    bodyTextView.isEditable = false
    bookmarkButton.isHidden = false
    deletePostButton.isHidden = true
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
      PostController.shared.update(post: post, title: title, subtitle: subtitleTextField.text, bodyText: bodyTextView.text, coverPhoto: coverPhoto) { post in
        DispatchQueue.main.async {
          guard let _ = post else { self.presentSimpleAlertWith(title: "Whoops something went wrong", body: "Please make sure you are connected to the internet, and you may have to try again later") ; return }
        }
      }
    }else{
      PostController.shared.createPost(title: title, subtitle: subtitleTextField.text, author: author, bodyText: bodyTextView.text, coverPhoto: coverPhoto) { post in
        
      }
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
  
  @IBAction func deletePostButtonTapped(_ sender: Any) {
    guard let post = post else { return }
    presentAreYouSureAlert(title: "Are you sure you want to delete this Post", body: "You cannot recover this conent after you delete it") { (_) in
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      PostController.shared.deletePost(post: post, completion: { (success) in
        DispatchQueue.main.async {
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
          if !success{
            self.presentSimpleAlertWith(title: "Whoops something went wrong", body: "Please make sure you are connected to the internet.  You may have to try again later ):")
          }else {
            self.navigationController?.popViewController(animated: true)
          }
        }
      })
    }
  }
}
//MARK: - PhotoSelectorViewControllerDelegate
extension PostDetailViewController: PhotoSelectorViewControllerDeleate{
  func photoSelected(_ photo: UIImage) {
    coverPhoto = photo
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toPhotoSelector"{
      let destination = segue.destination as! PhotoSelectorViewController
      photoSelectorViewController = destination
      destination.delegate = self
      destination.imageUrlString = post?.thumbnailUrl
    }
  }
}
