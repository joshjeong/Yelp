//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Josh Jeong on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var business: Business! {
        didSet {
            if let imageURL = business.imageURL {
                thumbnailImageView.setImageWith(imageURL)
            }
            
            if let name = business.name {
                nameLabel.text = name
            }
            
            if let ratingImgURL = business.ratingImgURL {
                ratingImageView.setImageWith(ratingImgURL)
            }
            
            if let reviewCount = business.reviewCount {
                reviewCountLabel.text = "\(reviewCount) Reviews"
                
            }
            addressLabel.text = business.addressString
            categoryLabel.text = business.categoriesString
            distanceLabel.text = business.distanceMiles
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 3
        thumbnailImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
