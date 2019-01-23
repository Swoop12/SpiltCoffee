//
//  UIViewExtension.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/7/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

extension UIView {
  var firstResponder: UIView? {
    guard !isFirstResponder else { return self }
    for subview in subviews {
      if let firstResponder = subview.firstResponder {
        return firstResponder
      }
    }
    return nil
  }
  
  func addShadow(){
    self.layer.shadowOffset = CGSize(width: 0, height: 0)
    self.layer.shadowRadius = 5
    self.layer.shadowOpacity = 0.3
  }
}
