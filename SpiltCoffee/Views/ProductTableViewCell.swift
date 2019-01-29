//
//  ProductTableViewCell.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/31/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

//MARK: - ProductTableViewCellDelegate
protocol ProductTableViewCellDelegate: class{
  func purchaseButtonPressed(sender: ProductTableViewCell)
}

class ProductTableViewCell: DataTableViewCell<Product> {
  
  //MARK: - IBOutlets
  @IBOutlet weak var productImageView: RoundedImageView!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  
  //MARK: - Properties
  weak var delegate: ProductTableViewCellDelegate?
  
  //MARK: - Methods
  override func updateViews(){
    if let product = data{
      productImageView.urlString = product.photoUrlStrings.first
    }
    productNameLabel.text = data?.name
    priceLabel.text = "$\(data?.price ?? 0)"
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    productImageView.image = nil
  }
  
  //MARK: - Actions
  @IBAction func purchaseButtonTapped(_ sender: Any) {
    delegate?.purchaseButtonPressed(sender: self)
  }
}
