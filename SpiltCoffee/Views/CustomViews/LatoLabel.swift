//
//  LatoTextField.swift
//  SpiltCoffee
//
//  Created by DevMountain on 2/8/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class LatoLabel: UILabel {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.updateFontTo(fontName: "Lato-Regular")
  }
  
  func updateFontTo(fontName: String){
    let size = self.font.pointSize
    self.font = UIFont(name: fontName, size: size)!
  }
}
