//
//  BookmarkCollectionViewCell.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/30/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class PostCollectionViewCell: DataCollectionViewCell<Post> {
  
  @IBOutlet weak var headerPhotoImageView: RoundedImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var likeButton: UIButton!
  @IBOutlet weak var likesCountLabel: UILabel!
  @IBOutlet weak var bookmarkButton: UIButton!  
  @IBOutlet weak var bgView: UIView!

  var isFavorite: Bool{
    guard let currentUser = UserController.shared.currentUser, let postId = self.data?.uuid else { return false }
    return currentUser.bookmarkIds.contains(postId)
  }
  
  override func updateViews(){
    guard let post = self.data else {return}
    headerPhotoImageView.urlString = post.thumbnailUrl
    titleLabel.text = post.title
    authorLabel.text = post.roasterInfo[RoasterConstants.nameKey]
    dateLabel.text = post.date.asString(dateStyle: .short, timeStyle: .short)
    updateBookmarButton()
  }
  
  func updateBookmarButton(){
    guard let post = self.data else {return}
    let bookmarkImage = isFavorite ? #imageLiteral(resourceName: "SolidBookmark") : #imageLiteral(resourceName: "HollowBookmark")
    bookmarkButton.setImage(bookmarkImage, for: .normal)
    likesCountLabel.text = "\(post.bookmarkCount)"
    
  }
  
  @IBAction func bookmarkButtonTapped(_ sender: Any) {
    guard let post = self.data else {return}
    isFavorite ? PostController.shared.unbookmark(post: post, completion: nil) : PostController.shared.bookmark(post: post, completion: nil)
    updateBookmarButton()
  }
}
