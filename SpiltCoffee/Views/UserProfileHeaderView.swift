//
//  UserHeaderView.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/3/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

protocol UserProfileHeaderViewDelegate: class {
    
    func followButtonTapped(sender: UserProfileHeaderView)
    
    func reportButtonTapped(sender: UserProfileHeaderView)
}

extension UserProfileHeaderViewDelegate {
    
    func followButtonTapped(sender: UserProfileHeaderView) {}
    
    func reportButtonTapped(sender: UserProfileHeaderView) {}
}

class UserProfileHeaderView: UIView {
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var productsStackView: UIStackView!
    @IBOutlet weak var roasterInfoStackView: UIStackView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!
    
    var enthusiast: Enthusiast?{
        didSet{
            updateViews()
        }
    }
    
    weak var delegate: UserProfileHeaderViewDelegate?
    
    var isFollowing: Bool{
        guard let currentUser = UserController.shared.currentUser, let enthusiastToFollow = enthusiast else { return false }
        return currentUser.followingIds.contains(enthusiastToFollow.uuid)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("UserProfileHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func updateViews(){
        guard let enthusiast = enthusiast else {return}
        followerCountLabel.text = "\(enthusiast.followerIds.count)"
        followingCountLabel.text = "\(enthusiast.followingIds.count)"
        profilePictureImageView.image = enthusiast.profilePicture
        
        if let roaster = enthusiast as? Roaster{
            locationLabel.text = "\(roaster.location ?? "")"
            companyLabel.text = roaster.companyName
            postCountLabel.text = "\(roaster.postIds.count)"
            productCountLabel.text = "\(roaster.productIds.count)"
        }else{
            roasterInfoStackView.isHidden = true
            productsStackView.isHidden = true
            postsLabel.text = "bookmarks"
            postCountLabel.text = "\(enthusiast.bookmarkIds.count)"
        }
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.2
        contentView.clipsToBounds = false
        contentView.layer.masksToBounds = false
        
        if enthusiast == UserController.shared.currentUser{
            followButton.isHidden = true
            reportButton.isHidden = true
        }else {
            followButton.isHidden = false
            reportButton.isHidden = false
            updateFollowButton()
        }
        
    }
    
    func updateFollowButton(){
        let followButtonTitle = isFollowing ? "Unfollow" : "Follow"
        followButton.setTitle(followButtonTitle, for: .normal)
    }
    
    @IBAction func followButtonTapped(_ sender: UIButton) {
        delegate?.followButtonTapped(sender: self)
        updateFollowButton()
    }
    
    @IBAction func reportButtonTapped(_ sender: Any) {
        delegate?.reportButtonTapped(sender: self)
        updateFollowButton()
    }
}
