//
//  CollectionViewCell4TwoCollectionViewCell.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock.
//  Copyright © 2018 DevMountain. All rights reserved.
//


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
// MARK: - Import

import UIKit


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
// MARK: - Class

class CoffeeBeanCollectionViewCell: DataCollectionViewCell<CoffeeBean> {


    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    // MARK: - Properties

    @IBOutlet weak var beanNameLabel: UILabel!
    @IBOutlet weak var beanImageView: UIImageView!

    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    // MARK: - Setup

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func fetchAndSetImage(){
        guard let bean = data, bean.photos.first == nil else {
            beanImageView.image = data?.photos.first
            return
        }
        
        FirestoreClient.shared.fetchFirstPhotosFor(bean) { (_) in
            DispatchQueue.main.async {
                self.beanImageView.image = bean.photos.first
            }
        }
    }

    override func updateViews(){
        guard let bean = data else {return}
        fetchAndSetImage()
        beanNameLabel.text = bean.name
    }
}
