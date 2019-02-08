//
//  LatoTextView.swift
//  SpiltCoffee
//
//  Created by DevMountain on 2/8/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class LatoTextView: UITextView {
  
  override func awakeFromNib(){
    super.awakeFromNib()
    updateFontTo(fontName: "Lato-Regular")
    self.textColor = .darkGray
  }
  
  func updateFontTo(fontName: String){
    guard let size = self.font?.pointSize else { return }
    self.font = UIFont(name: fontName, size: size)
  }
}
