//
//  EditProductTableViewCell.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/31/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class EditProductTableViewCell: DataTableViewCell<Product> {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var editProductButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var product: Product?{
        didSet{
            updateView()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView(){
        guard let product = product else {return}
        if let photo = product.photos.first{
            productImageView.image = photo
        }
        productNameLabel.text = product.name
        priceLabel.text = "$\(product.price)"
    }

//    func setUpUI(){
//        // editProductButtonButton
//        self.editProductButton.layer.borderColor = UIColor(red: 0.71, green: 0.56, blue: 0.44, alpha: 1).cgColor
//        self.editProductButton.layer.borderWidth = 1.0
//        self.editProductButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
//        self.editProductButton.layer.shadowRadius = 2.0
//        self.editProductButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        self.editProductButton.layer.shadowOpacity = 1.0
//        self.editProductButton.layer.masksToBounds = false
//        self.editProductButton.layer.cornerRadius = 10.0
//    }
    
}
