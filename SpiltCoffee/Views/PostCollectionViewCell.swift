//
//  BookmarkCollectionViewCell.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/30/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class PostCollectionViewCell: DataCollectionViewCell<Post> {
    
    @IBOutlet weak var headerPhotoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        bgView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
//        bgView.layer.shadowRadius = 5.0
//        bgView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        bgView.layer.shadowOpacity = 1.0
//        bgView.layer.masksToBounds = false
//        bgView.layer.cornerRadius = 10.0
//        headerPhotoImageView.layer.cornerRadius = 10.0
//    }
    
    var isFavorite: Bool{
        guard let currentUser = UserController.shared.currentUser, let postId = self.data?.uuid else { return false }
        return currentUser.bookmarkIds.contains(postId)
    }
    
    override func updateViews(){
        guard let post = self.data else {return}
        fetchPhotosForPost()
        titleLabel.text = post.title
        authorLabel.text = post.roasterMap[PostConstants.roasterNameKey]
        dateLabel.text = post.date.asString(dateStyle: .short, timeStyle: .short)
        
        
        updateBookmarButton()
    }
    
    func updateBookmarButton(){
        guard let post = self.data else {return}
        let bookmarkImage = isFavorite ? #imageLiteral(resourceName: "SolidBookmark") : #imageLiteral(resourceName: "HollowBookmark")
        bookmarkButton.setImage(bookmarkImage, for: .normal)
        likesCountLabel.text = "\(post.bookmarkCount)"
    }
    
    func fetchPhotosForPost(){
        guard let post = self.data else {return}
        FirestoreClient.shared.fetchFirstPhotosFor(post) { (success) in
            if success{
                self.headerPhotoImageView.image = post.photos.first ?? #imageLiteral(resourceName: "DefaultPicture")
            }else {
                print("Unsucessful fetching first photo):")
                self.headerPhotoImageView.image = #imageLiteral(resourceName: "profile")
            }
        }
    }
    
    @IBAction func bookmarkButtonTapped(_ sender: Any) {
        guard let post = self.data else {return}
        isFavorite ? PostController.shared.unbookmark(post: post, completion: nil) : PostController.shared.bookmark(post: post, completion: nil)
        updateBookmarButton()
    }
}
