//
//  RestaurantDetailHeaderView.swift
//  FoodPin
//
//  Created by Adam Iwaszkiewicz UCTI on 22/09/2022.
//

import UIKit

class RestaurantDetailHeaderView: UIView {

    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!{
        didSet{
            nameLabel.numberOfLines = 0
        }
    }
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var heartButton: UIButton!

}
