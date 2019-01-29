//
//  PhotoViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 1/27/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
  
  @IBOutlet private weak var photoImageView: UIImageView!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    }
  
  func setPhoto(_ image: UIImage){
    self.loadViewIfNeeded()
    photoImageView.image = image
  }
}
