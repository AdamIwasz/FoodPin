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
            
            if let customFont = UIFont(name: "Nunito-Bold", size: 40.0){
                nameLabel.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: customFont)
            }
        }
    }
    @IBOutlet var typeLabel: UILabel!{
        didSet{
            nameLabel.numberOfLines = 0
            if let customFont = UIFont(name: "Nunito-Bold", size: 20.0){
                typeLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)
            }
        }
    }
    @IBOutlet var heartButton: UIButton!
    @IBOutlet var ratingImageView: UIImageView!
    
}
