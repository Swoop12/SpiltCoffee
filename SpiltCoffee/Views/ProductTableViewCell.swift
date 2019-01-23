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
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  
  //MARK: - Properties
  weak var delegate: ProductTableViewCellDelegate?
  
  //MARK: - Methods
  override func updateViews(){
    if let product = data{
      fetchFirstImage(for: product)
    }
    productNameLabel.text = data?.name
    priceLabel.text = "$\(data?.price ?? 0)"
  }
  
  func fetchFirstImage(for product: Product){
    FirestoreClient.shared.fetchFirstPhotosFor(product) { (success) in
      if success{
        DispatchQueue.main.async {
          self.productImageView.image = product.photos.first
        }
      }
    }
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
