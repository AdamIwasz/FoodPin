//
//  DiscoverTableViewCell.swift
//  FoodPin
//
//  Created by Adam Iwaszkiewicz UCTI on 27/10/2022.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!{
        didSet{
            nameLabel.numberOfLines = 0
            nameLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet var locationLabel: UILabel!{
        didSet{
            locationLabel.numberOfLines = 0
            locationLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet var typeLabel: UILabel!{
        didSet{
            typeLabel.numberOfLines = 0
            typeLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet var descriptionLabel: UILabel!{
        didSet{
            descriptionLabel.numberOfLines = 0
            descriptionLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet var thumbnailImageView: UIImageView!{
        didSet{
            thumbnailImageView.layer.cornerRadius = 30.0
            thumbnailImageView.clipsToBounds = true
        }
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
