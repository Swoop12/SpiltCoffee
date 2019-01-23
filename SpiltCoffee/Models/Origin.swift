//
//  Country.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/31/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

struct Origin{
    
    let name: String
    var image: UIImage?
    
    init(name: String){
        self.name = name
    }
    
    static let countries: [Origin] = {
        return [
        Origin(name: "Ethiopia"),
        Origin(name: "Columbia"),
        Origin(name: "Kenya"),
        Origin(name: "Guatemala"),
        Origin(name: "Brazil"),
        Origin(name: "El Salvador"),
        Origin(name: "Rwanda"),
        Origin(name: "Uganda"),
        Origin(name: "Nicaragua"),
        Origin(name: "Dominican Republic"),
        Origin(name: "Honduras"),
        Origin(name: "Burundi"),
        Origin(name: "Papua New Guinea"),
        Origin(name: "Costa Rica"),
        Origin(name: "Puerto Rico"),
        Origin(name: "Bolivia"),
        Origin(name: "Mexico"),
        Origin(name: "Hawaii"),
        Origin(name: "Ivory Coast"),
        Origin(name: "Yemen"),
        Origin(name: "Indonesia"),
        Origin(name: "Vietnam")
        ]
    }()
}

