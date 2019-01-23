//
//  CollectionViewCell.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/5/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: DataCollectionViewCell<UIImage> {
    
    
    @IBOutlet weak var photoImageView: UIImageView!

    override func updateViews() {
        guard let photo = data else {return}
        self.photoImageView.image = photo
    }
    
}
