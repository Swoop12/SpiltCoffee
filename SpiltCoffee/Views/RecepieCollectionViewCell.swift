//
//  Group3ThreeCollectionViewCell.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock.
//  Copyright © 2018 DevMountain. All rights reserved.
//
import UIKit

class RecpeieCollectionViewCell: DataCollectionViewCell<Recepie> {
  
  //MARK: - IBOutlets
  @IBOutlet weak var bgView: UIView!
  @IBOutlet weak var headerImageView: RoundedImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var brewTimeLabel: UILabel!

  //MARK: - Methods
  override func updateViews(){
    guard let recepie = data else {return}
    if let url = recepie.photoUrlStrings.first{
      headerImageView.urlString = url
    }else{
      headerImageView.image = recepie.brewMethod.image
    }
    titleLabel.text = recepie.title
    brewTimeLabel.text = "Brew Time: \(recepie.brewTimeInMinutes) min"
  }
}
