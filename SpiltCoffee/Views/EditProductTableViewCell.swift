//
//  EditProductTableViewCell.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/31/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class EditProductTableViewCell: DataTableViewCell<Product> {
    
    @IBOutlet weak var productImageView: ThumbNailImageView!
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
        productImageView.urlString = product.photoUrlStrings.first
        productNameLabel.text = product.name
        priceLabel.text = "$\(product.price)"
    }
}
