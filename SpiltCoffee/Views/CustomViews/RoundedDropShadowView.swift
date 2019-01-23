//
//  RoundedDropShadowView.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/17/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class RoundedDropShadowView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stylize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        stylize()
    }
    
    func stylize(){
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
}
