//
//  OriginTableViewCell.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/31/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class OriginTableViewCell: UITableViewCell{
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var originNameLabel: UILabel!
    
    var origin: Origin?{
        didSet{
            updateViews()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        bgImage.image = nil
    }
    
    func updateViews(){
        originNameLabel.text = origin?.name
        let urlName = origin?.name.replacingOccurrences(of: " ", with: "")
        if let image = origin?.image{
            self.bgImage.image = image
        }else{
            FirestoreClient.shared.fetchPhotoFromStorage(for: "Origins/\(urlName ?? "unknown").jpg") { (image) in
                guard let image = image else { return }
                self.origin?.image = image
            }
        }
    }

}
