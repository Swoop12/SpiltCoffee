//
//  PhotoPagerCell.swift
//  SpiltCoffee
//
//  Created by DevMountain on 2/2/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

protocol PhotoPagerCellDelegate: class {
  func photoRetrieved(photo: UIImage, urlString: String)
}

class PhotoPagerCell: UICollectionViewCell, FetchingImageViewDelegate{
  
  @IBOutlet weak var photoImageView : FetchingImageView!
  weak var delegate: PhotoPagerCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    photoImageView.delegate = self
  }
  
  func photoRetrieved(photo: UIImage, urlString: String) {
    delegate?.photoRetrieved(photo: photo, urlString: urlString)
  }
}
