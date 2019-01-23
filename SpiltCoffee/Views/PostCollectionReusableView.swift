//
//  PostCollectionReusableView.swift
//  SpiltCoffee
//
//  Created by DevMountain on 11/4/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class PostCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var addPostButton: UIButton!
    
    var bio: String?{
        didSet{
            bioLabel.text = bio
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func addPostButtonTapped(_ sender: Any) {
        
    }
}
