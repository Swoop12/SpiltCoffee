//
//  ThumbNailImageView.swift
//  SpiltCoffee
//
//  Created by DevMountain on 1/28/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class ThumbNailImageView: UIImageView {
  
  var urlString: String?{
    didSet{
      loadAndDisplayImage()
    }
  }
  
  func loadAndDisplayImage(){
    guard let urlString = urlString else { hide() ; return }
    FirestoreClient.shared.fetchPhotoFromStorage(for: urlString) { (image) in
      DispatchQueue.main.async {
        if let image = image{
          self.image = image
        }else {
          self.hide()
        }
      }
    }
  }
  
  private func hide(){
    isHidden = true
  }
}
