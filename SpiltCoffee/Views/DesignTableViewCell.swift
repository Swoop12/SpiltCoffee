//
//  DesignTableViewCell.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/15/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class DesignTableViewCell: DataTableViewCell<DesignCellData> {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func updateViews() {
        guard let designData = data else {return}
        bgImageView.image = designData.image
        titleLabel.text = designData.name
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
