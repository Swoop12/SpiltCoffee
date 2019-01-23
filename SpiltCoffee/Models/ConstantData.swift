//
//  ConstantData.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/15/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

struct ConstantData: DesignCellData{
    
    let name: String
    let image: UIImage
    
    static let productCategories = [
        ConstantData(name: "Bean", image: #imageLiteral(resourceName: "beans")),
        ConstantData(name: "Brewing", image: #imageLiteral(resourceName: "brewing")),
        ConstantData(name: "Kettle", image: #imageLiteral(resourceName: "kettle")),
        ConstantData(name: "Grinder", image: #imageLiteral(resourceName: "grinder")),
        ConstantData(name: "Scale", image: #imageLiteral(resourceName: "scale"))
    ]
    
    static let beanSelection = [
        ConstantData(name: "Origin", image: #imageLiteral(resourceName: "DefaultPicture")),
        ConstantData(name: "Roaster", image: #imageLiteral(resourceName: "DefaultPicture"))
    ]
}

struct BrewMethod: DesignCellData{
    
    let name: String
    let image: UIImage
    let url: String
    let about: String
    
    static func getBrewMethod(name: String) -> BrewMethod?{
        switch name {
        case "Pour-Over":
            return BrewMethod.brewCategories[0]
        case "Chemex":
            return BrewMethod.brewCategories[1]
        case "AeroPress":
            return BrewMethod.brewCategories[2]
        case "French Press":
            return BrewMethod.brewCategories[3]
        default:
            return nil
        }
    }
    
    static let brewCategories = [
        BrewMethod(name: "Pour-Over", image: #imageLiteral(resourceName: "pourOver"),url: "Pour Over1", about: "A pour-over is a single cup brew method that makes a balanced cup of coffee and is the standard for many specialty coffee shops around the world. It allows for manipulation of many variables giving the brewing control over the flavor of the coffee. There are many different systems each with their own advantages. Some are coned shaped like the Hario V60, while other have a flat bottom, like the Fellow Stagg Pour-Over System. While each system gives a unique taste to a coffee, they all brew by using water and gravity. One major decision you will want to make is whether to use a paper filter system or a metal filter one. Paper filters will remove much of the oil when brewing which allows for brighter more fruit forward notes. Metal filters will allow more oil to make it into your cup making for a more bitter coffee"),
        BrewMethod(name: "Chemex", image: #imageLiteral(resourceName: "Chemex"),url: "Chemex1", about:
"""
A Chemex is a single or multi cup brew method that has been around since 1940. Despite its age, the brew method remains very popular to this day. The iconic shape looks more like a piece of decor than a functional brew method, but all that form isn’t without function. It offers a fair amount of manipulation to the brewer and is convenient when brewing multiple cups. The Chemex uses large specially designed paper filters that have a deep cone. The depth of the cone can cause coffee grounds to group together and not allow water to flow through. To prevent this from happening, pour water in the center of the filter to push the grounds outward.

"""),
        BrewMethod(name: "AeroPress", image: #imageLiteral(resourceName: "aeropress"), url: "AeroPress" ,about: "The AeroPress is a modern single cup brew method known best for its simplistic versatility and compact shape. It consists of a cylindrical tube and a plunger and uses suction during brewing making it somewhat of a cross between an espresso machine and a French Press. It is very compact making it a favorite for those who are on the go or camping. The AeroPress is perfect for anyone ready to experiment. "),
        BrewMethod(name: "French Press", image: #imageLiteral(resourceName: "frenchPress"), url: "https://player.vimeo.com/video/299756504", about: "The French press is a simple brewing method with a metal filter. This brew method works by steeping the coffee grounds much like tea rather than running them through a filter. By steeping the coffee grounds, the French press offers a more bold and bitter flavor as the grounds have more contact with the water. This method gives less control but makes up for it with it’s simplicity. ")
    ]
}
