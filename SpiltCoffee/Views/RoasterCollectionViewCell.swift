//
//  Group8Copy2TwoCollectionViewCell.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock.
//  Copyright © 2018 DevMountain. All rights reserved.
//


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
// MARK: - Import

import UIKit


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
// MARK: - Class

class RoasterCollectionViewCell: DataCollectionViewCell<Roaster> {
    
    @IBOutlet weak var profileImageView: UIImageView!
//    @IBOutlet weak var coverPhotoImageView: UIImageView!

    @IBOutlet weak var bgView: RoundedDropShadowView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var productsCountLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func updateViews(){
        
        guard let roaster = data else {return}
        bgView.layer.masksToBounds = false
//        coverPhotoImageView.image = roaster.coverPhoto
        nameLabel.text = roaster.name
        companyLabel.text = roaster.companyName
        followersCountLabel.text = "\(roaster.followerIds.count)"
        followingCountLabel.text = "\(roaster.followingIds.count)"
        postsCountLabel.text = "\(roaster.postIds.count)"
        productsCountLabel.text = "\(roaster.productIds.count)"
        locationLabel.text = roaster.shops.first?.address
        fetchAndSetProfilePicture()
    }
    
    func fetchAndSetProfilePicture(){
        guard let roaster = data else { return }
        if let profile = roaster.profilePicture{
            profileImageView.image = profile
        }else {
            UserController.shared.fetchProfilePicture(for: roaster) { (photo) in
                DispatchQueue.main.async {
                    self.profileImageView.image = photo
                }
            }
        }
    }
}
