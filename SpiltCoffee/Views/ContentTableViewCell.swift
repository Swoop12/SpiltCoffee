//
//  ContentTableViewCell.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/30/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

protocol ContentTableViewCellDelegate: class {
    func cartButtonPressed(sender: ContentTableViewCell)
}

class ContentTableViewCell: DataTableViewCell<Post> {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var photoHeaderImageView: UIImageView!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesCountLabel: UILabel!
    
    weak var delegate: ContentTableViewCellDelegate?
    
    var post: Post? {
        didSet{
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateView(){
        guard let post = post else {return}
        photoHeaderImageView.image = post.photos.first
        titleLabel.text = post.title
        authorLabel.text = post.author?.name
        dateLabel.text = post.date.description
        likesCountLabel.text = "\(post.likesCount)"
    }
    
    
//    fileprivate func setupUI() {
//        // cardviewView
//        bgView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
//        bgView.layer.shadowRadius = 5.0
//        bgView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        bgView.layer.shadowOpacity = 1.0
//        bgView.layer.masksToBounds = false
//        bgView.layer.cornerRadius = 23.0
//        photoHeaderImageView.layer.cornerRadius = 23.0
//    }

}
