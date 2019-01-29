//
//  FirebaseFetchable.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/11/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import Firebase

protocol AbridgedDictionary{
  var abridgedDictionary: [String : String] {get}
}

protocol FirestoreFetchable{
  //MARK: - Properties
  var uuid: String {get}
  static var CollectionName: String {get}
  
  //MARK: - Initializers
  init?(dictionary: [String : Any], id: String)
}

extension FirestoreFetchable {
  
  var collectionReference: CollectionReference{
    return Firestore.firestore().collection(Self.CollectionName)
  }
  
  var documentReference: DocumentReference{
    return Firestore.firestore().document("\(Self.CollectionName)/\(uuid)")
  }
  
  ///A Dictionary Representation of the object which conforms to FirestoreFetchable with the paramenter namees as String and the values cast as Any
  ///
  ///The dictionary should not contain values which are not in the standard library. Custom objects should either conform to the CustomEnum or AbridgedDictionary Protocols.  CustomEnum objects will save rawValues as the dictionary values, AbridgedDictionaries will save the value of the abridgedDictionary property
  var dictionary: [String : Any]{
    let mirroredObject = Mirror(reflecting: self)
    var dict: [String : Any] = [:]
    for (_, attribute) in mirroredObject.children.enumerated(){
      if let propertyName = attribute.label as String? {
        if let abbridgedDictionaryClass = unwrap(any: attribute.value) as? AbridgedDictionary{
          dict[propertyName] = abbridgedDictionaryClass.abridgedDictionary
        }else if let enumValue = attribute.value as? CustomEnum{
          dict[propertyName] = enumValue.rawValue
        }else if let origin = attribute.value as? Origin{
          dict[propertyName] = origin.name
        }else if attribute.value is String || attribute.value is Int || attribute.value is Double || attribute.value is [String] || attribute.value is [Int]{
          dict[propertyName] = attribute.value
        }
      }
    }
    return dict
  }
  
  /**Unwraps instances of Any wich may have an Optional Type.  This should only be used if an Any object may actually be nil.
  - Parameter any: The object you wish to unwrap
  - Parameter ifNil: The value to be returned if unwrapping the any object returns nil.  The default value is the string "nil" cast as Any
  - Returns: Returns the unwraped value as Any or the value of the ifNil arguement
 */
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
