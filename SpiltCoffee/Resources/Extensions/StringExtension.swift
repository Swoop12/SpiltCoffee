//
//  StringExtension.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/2/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
}

extension Optional where Wrapped == String {
    
    func isEmptyOrNil() -> Bool{
        return self?.isEmpty ?? true
    }
    
}
