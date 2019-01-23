//
//  RoasterTableViewCell.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/31/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class RoasterTableViewCell: DataTableViewCell<Roaster> {

    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var productsCountLabel: UILabel!
    
    var roaster: Roaster? {
        didSet{
           updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView(){
        guard let roaster = roaster else {return}
        profileImageView.image = roaster.profilePicture
        nameLabel.text = roaster.name
        companyLabel.text = roaster.companyName
        locationLabel.text = "\(roaster.shops.first?.address ?? "")"
        followerCountLabel.text = "\(roaster.followerIds.count)"
        followingCountLabel.text = "\(roaster.followingIds.count)"
        postsCountLabel.text = "\(roaster.postIds.count)"
        productsCountLabel.text = "\(roaster.productIds.count)"
    }

}
