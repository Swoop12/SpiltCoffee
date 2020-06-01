//
//  DataSourceController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/2/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class DataViewGenericDataSource<T>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate{
  
  //MARK: - Properties
  var sourceOfTruth: [T]
  var dataType: DataType
  var roasterBio: String?
  var buttonIsHidden: Bool?
  var constantRowHeight: CGFloat?
  weak var delegate: GenericDataSourceVCDelegate?
  
  //MARK: - Initializers
  init(dataView: DataView, dataType: DataType, data: [T]) {
    self.dataType = dataType
    dataView.registerNib(nibName: dataType.nibName, cellIdentifier: dataType.reuseIdentifier)
    
    self.sourceOfTruth = data
    super.init()
    assignDelegateAndDataSource(to: dataView)
  }
  
  //MARK: - Methods
  func assignDelegateAndDataSource(to dataView: DataView){
    if let tableView = dataView as? UITableView{
      tableView.delegate = self
      tableView.dataSource = self
    }else if let collectionView = dataView as? UICollectionView{
      collectionView.delegate = self
      collectionView.dataSource = self
    }
  }
  
  //MARK: - UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sourceOfTruth.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: dataType.reuseIdentifier, for: indexPath) as? DataTableViewCell<T>
    let data = sourceOfTruth[indexPath.row]
    cell?.data = data
    return cell ?? UITableViewCell()
  }
  
  //MARK: - UICollectionViewDataSource
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sourceOfTruth.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dataType.reuseIdentifier, for: indexPath) as? DataCollectionViewCell<T>
    let data = sourceOfTruth[indexPath.row]
    cell?.data = data
    return cell ?? UICollectionViewCell()
  }
  
  //MARK: - UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.prepareAndPerformSegue(for: dataType, with: sourceOfTruth[indexPath.row])
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return constantRowHeight ?? 100
  }
  
  //MARK: - UICollectionViewDelegate
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.prepareAndPerformSegue(for: dataType, with: sourceOfTruth[indexPath.row])
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "postHeader", for: indexPath) as? PostCollectionReusableView
    headerView?.frame.size.height = 100
    headerView?.bio = roasterBio
    headerView?.addPostButton.isHidden = self.buttonIsHidden ?? true
    return headerView ?? PostCollectionReusableView()
  }
}
