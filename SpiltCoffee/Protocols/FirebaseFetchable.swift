//
//  FirebaseFetchable.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/11/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

protocol AbridgedDictionary{
    
    var abridgedDictionary: [String : Any] {get}
    
}

protocol FirestoreFetchable{
    
    init?(dictionary: [String : Any])
    
    static var CollectionName: String {get}
}

extension FirestoreFetchable {
    
    var dictionary: [String : Any]{
        let mirroredObject = Mirror(reflecting: self)
        var dict: [String : Any] = [:]
        for (_, attribute) in mirroredObject.children.enumerated(){
            if let propertyName = attribute.label as String? {
                if let abbridgedDictionaryClass = unwrap(any: attribute.value) as? AbridgedDictionary{
                    print("Hit the dictionary")
                    dict[propertyName] = abbridgedDictionaryClass.abridgedDictionary
                }else{
                    print(propertyName, attribute.value)
                    dict[propertyName] = attribute.value
                }
            }
        }
        return dict
    }
    
    func unwrap(any:Any, ifNil: Any = "nil") -> Any {
        
        let mi = Mirror(reflecting: any)
        if mi.displayStyle != .optional {
            return any
        }
        
        if mi.children.count == 0 { return ifNil }
        let (_, some) = mi.children.first!
        return some as Any
    }
}
