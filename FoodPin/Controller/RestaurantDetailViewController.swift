//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Adam Iwaszkiewicz UCTI on 20/09/2022.
//

import UIKit

class RestaurantDetailViewController: UIViewController {

    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var restaurantLocationLabel: UILabel!
    @IBOutlet var restaurantTypeLabel: UILabel!
    @IBOutlet var restaurantInformationStack: UIStackView!{
        didSet{
            restaurantInformationStack.layer.cornerRadius = 20
            restaurantInformationStack.clipsToBounds = true
        }
    }
    
    
    var restaurnt = Restaurant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        restaurantImageView.image = UIImage(named: restaurnt.image)
        restaurantNameLabel.text = restaurnt.name
        restaurantLocationLabel.text = restaurnt.location
        restaurantTypeLabel.text = restaurnt.type
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
