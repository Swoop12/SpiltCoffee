//
//  FetchImageView.swift
//  SpiltCoffee
//
//  Created by DevMountain on 2/2/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

protocol FetchingImageViewDelegate: class {
  func photoRetrieved(photo: UIImage, urlString: String)
}

class FetchingImageView: UIImageView {
  
  weak var delegate: FetchingImageViewDelegate?
  var photoSource: PhotoSource?{
    didSet{
      loadAndDisplayImage()
    }
  }
  
  func loadAndDisplayImage(){
    if let photo = photoSource?.photo{
      self.image = photo
    }else if let urlString = photoSource?.imageUrl{
      FirestoreClient.shared.fetchPhotoFromStorage(for: urlString) { (image) in
        DispatchQueue.main.async {
          if let image = image{
            self.image = image
            print(self.delegate)
            self.delegate?.photoRetrieved(photo: image, urlString: urlString)
          }
        }
      }
    }
  }
  
  private func hide(){
    isHidden = true
  }
}
