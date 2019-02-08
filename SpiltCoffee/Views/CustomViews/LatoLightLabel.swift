//
//  LatoLightLabel.swift
//  SpiltCoffee
//
//  Created by DevMountain on 2/8/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import Foundation

class LatoLightLabel: LatoLabel {
  override func awakeFromNib() {
    super.awakeFromNib()
    updateFontTo(fontName: "Lato-Light")
  }
}
