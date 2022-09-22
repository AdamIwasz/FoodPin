//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Adam Iwaszkiewicz UCTI on 20/09/2022.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: RestaurantDetailHeaderView!
    
    var restaurnt = Restaurant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        
        headerView.nameLabel.text = restaurnt.name
        headerView.typeLabel.text = restaurnt.type
        headerView.headerImageView.image = UIImage(named: restaurnt.image)
        
        let heartImage = restaurnt.isFavorite ? "heart.fill" : "heart"
        headerView.heartButton.tintColor = restaurnt.isFavorite ? .systemYellow : .white
        headerView.heartButton.setImage(UIImage(systemName: heartImage), for: .normal)
        
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
