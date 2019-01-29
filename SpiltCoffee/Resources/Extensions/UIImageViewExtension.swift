//
//  UIImageViewExtension.swift
//  SpiltCoffee
//
//  Created by DevMountain on 1/27/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
