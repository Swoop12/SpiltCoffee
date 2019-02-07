//
//  Recepie.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/26/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class Recepie: FirestorePhotos{
  
    static let CollectionName: String = "Recipes"
  
    var uuid: String
    var title: String
    var brewTimeInMinutes: Int
    var brewMethod: BrewMethod
    var instructions: String
    var photosData: [Data] = []
    var photoUrlStrings: [String]
    
    init(title: String, photos: [UIImage], difficultyLevel: String, brewTimeInMinutes: Int, body: String, brewMethod: BrewMethod, uuid: String = UUID().uuidString){
        self.title = title
        self.brewTimeInMinutes = brewTimeInMinutes
        self.instructions = body
        self.uuid = uuid
        self.photoUrlStrings = []
        self.brewMethod = brewMethod
    }
  
  required init?(dictionary: [String : Any], id: String) {
    guard let title = dictionary["title"] as? String,
      let brewTimeInMinutes = dictionary["brewTimeInMinutes"] as? Int,
      let instructions = dictionary["instructions"] as? String,
      let brewString = dictionary["brewMethod"] as? String,
      let brewMethod = BrewMethod.getBrewMethod(name: brewString) else {return nil}
    
    let photoUrlStrings = dictionary["photoUrlStrings"] as? [String]
    
    self.title = title
    self.brewTimeInMinutes = brewTimeInMinutes
    self.instructions = instructions
    self.photoUrlStrings = photoUrlStrings ?? []
    self.uuid = id
    self.brewMethod = brewMethod
  }
}
