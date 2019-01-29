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
  
  func lockTextEditing(){
    for subview in subviews{
      if let textView = subview as? UITextView{
        textView.isEditable = false
      }
      if let textField = subview as? UITextField{
        textField.isUserInteractionEnabled = false
      }
    }
  }
  
  func allowTextEditting(){
    for subview in subviews{
      if let textView = subview as? UITextView{
        textView.isEditable = true
      }
      if let textField = subview as? UITextField{
        textField.isUserInteractionEnabled = true
      }
    }
  }
  
  func anchor (top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingBottom: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat){
    self.translatesAutoresizingMaskIntoConstraints = false
    if let top = top{
      topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
    }
    if let left = left {
      leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
    }
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
    }
    if let right = right{
      rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
    }
    if width != 0 {
      widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    if height != 0 {
      heightAnchor.constraint(equalToConstant: height).isActive = true
    }
  }
}
