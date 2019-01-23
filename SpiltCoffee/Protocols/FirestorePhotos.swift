//
//  ComputedPhotos.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/11/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

protocol FirestorePhotos: class, FirestoreFetchable{
  //MARK: - Properties
  var photosData: [Data] {get set}
  var photoUrlStrings: [String] {get set}
}

extension FirestorePhotos{
  
  ///A gettable & settable property which converts between the objects photoData property and UIImage representaitons
  var photos: [UIImage] {
    get{
      var imagesArray: [UIImage] = []
      let datas = photosData
      for data in datas{
        if let image = UIImage(data: data) {
          imagesArray.append(image)
        }
      }
      return imagesArray
    }
    set{
      var dataArray: [Data] = []
      for photo in newValue{
        if let data = UIImageJPEGRepresentation(photo, 0.25){
          dataArray.append(data)
        }
      }
      self.photosData = dataArray
    }
  }
}
