//
//  LatoButton.swift
//  SpiltCoffee
//
//  Created by DevMountain on 2/8/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class LatoButton: UIButton {
  
  override func awakeFromNib(){
    super.awakeFromNib()
    updateFontTo(fontName: "Lato-Regular")
  }
  
  func updateFontTo(fontName: String){
    guard let size = self.titleLabel?.font.pointSize else { return }
    self.titleLabel?.font = UIFont(name: fontName, size: size)
  }
}
