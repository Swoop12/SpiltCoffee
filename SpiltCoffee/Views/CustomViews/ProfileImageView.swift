//
//  ProfileImageView.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/17/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stylize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        stylize()
    }
    
    func stylize(){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
    }
}

class CircularImageView: UIImageView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stylize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        stylize()
    }

    override func didMoveToSuperview() {
        stylize()
    }
    
    func stylize(){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.width/2
    }
    
}
