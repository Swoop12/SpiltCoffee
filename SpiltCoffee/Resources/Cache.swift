//
//  Cache.swift
//  SpiltCoffee
//
//  Created by DevMountain on 1/28/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import Foundation

class Cache<T>{
  
  //MARK: - Properties
  private var cacheDictionary: [String : T] = [:]
  private var keysArray: [String] = []
  
  //MARK: - Methods
  private func removeOldestItem(){
    let firstKey = keysArray.removeFirst()
    cacheDictionary.removeValue(forKey: firstKey)
  }
  
  private func removeKeyfromArray(key: String){
    guard let index = keysArray.index(of: key) else { return }
    keysArray.remove(at: index)
  }
  
  public func insert(_ object: T, key: String){
    if cacheDictionary[key] != nil{
      removeKeyfromArray(key: key)
    }
    cacheDictionary[key] = object
    keysArray.append(key)
    if cacheDictionary.count == 50{
      removeOldestItem()
    }
  }
  
  public func obejectFor(key: String) -> T?{
    return cacheDictionary[key]
  }
  
  public func deleteObjectFor(key: String){
    cacheDictionary.removeValue(forKey: key)
  }
}
