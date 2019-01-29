//
//  CollectionViewCell4TwoCollectionViewCell.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock.
//  Copyright © 2018 DevMountain. All rights reserved.
//
import UIKit

class CoffeeBeanCollectionViewCell: DataCollectionViewCell<CoffeeBean> {

    // MARK: - Properties
    @IBOutlet weak var beanNameLabel: UILabel!
    @IBOutlet weak var beanImageView: RoundedImageView!

    override func updateViews(){
        guard let bean = data else {return}
        beanImageView.urlString = bean.photoUrlStrings.first
        beanNameLabel.text = bean.name
    }
}
