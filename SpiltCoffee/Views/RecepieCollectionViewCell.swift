//
//  Group3ThreeCollectionViewCell.swift
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

class RecpeieCollectionViewCell: DataCollectionViewCell<Recepie> {


    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    // MARK: - Properties

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var brewTimeLabel: UILabel!

    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
    // MARK: - Setup

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func updateViews(){
        guard let recepie = data else {return}
        headerImageView.image = recepie.photos.first ?? recepie.brewMethod.image
        titleLabel.text = recepie.title
        brewTimeLabel.text = "Brew Time: \(recepie.brewTimeInMinutes) min"
        
    }
}
