//
//  UserHeaderView.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/3/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class UserProfileHeaderView: UIView {

    
    
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!
    
    var enthusiast: Enthusiast?{
        didSet{
            updateViews()
        }
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
        let nib = UINib(nibName: "UserHeaderView", bundle: Bundle.main)
        print(nib)
        let contentView = nib.instantiate(withOwner: self, options: nil) as! UIView
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func updateViews(){
        guard let enthusiast = enthusiast else {return}
        
        profilePictureImageView.image = enthusiast.profilePicture
        coverPhotoImageView.image = enthusiast.coverPhoto
    }
}
