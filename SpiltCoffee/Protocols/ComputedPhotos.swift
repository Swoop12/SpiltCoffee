//
//  ComputedPhotos.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/11/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

protocol FirestorePhotos: class{
    
    var photosData: [Data]? {get set}
}

extension FirestorePhotos{
    
    var photos: [UIImage]? {
        get{
            var imagesArray: [UIImage] = []
            guard let datas = photosData else {return nil}
            for data in datas{
                if let image = UIImage(data: data) {
                    imagesArray.append(image)
                }
            }
            return imagesArray
        }
        set{
            var dataArray: [Data] = []
            guard let photos = newValue else { return }
            for photo in photos{
                if let data = UIImageJPEGRepresentation(photo, 0.5){
                    dataArray.append(data)
                }
            }
            self.photosData = dataArray
        }
    }
}
