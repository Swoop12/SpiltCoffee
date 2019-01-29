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
    @IBOutlet weak var photoHeaderImageView: RoundedImageView!
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
        photoHeaderImageView.urlString = post.thumbnailUrl
        titleLabel.text = post.title
        authorLabel.text = post.roasterInfo["authorName"]
        dateLabel.text = post.date.description
        likesCountLabel.text = "\(post.likesCount)"
    }
}
