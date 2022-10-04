//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Adam Iwaszkiewicz UCTI on 20/09/2022.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: RestaurantDetailHeaderView!
    
    @IBAction func close(segue: UIStoryboardSegue){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateRestaurant(segue: UIStoryboardSegue){
        
        guard let identifier = segue.identifier else {
            return
        }
        
        
        dismiss(animated: true, completion: {
            
            if let raiting = Restaurant.Rating(rawValue: identifier){
                self.restaurnt.rating = raiting
                self.headerView.ratingImageView.image = UIImage(named: raiting.image)
            }
            
            let scaleTransform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            self.headerView.ratingImageView.transform = scaleTransform
            self.headerView.ratingImageView.alpha = 0.0
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
                self.headerView.ratingImageView.transform = .identity
                self.headerView.ratingImageView.alpha = 1.0
            }, completion: nil)
        })
    }
    
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
        
        // chceck if rating is already set, if so set ratingImageView image
        if let raiting = self.restaurnt.rating{
            self.headerView.ratingImageView.image = UIImage(named: raiting.image)
        }
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInsetAdjustmentBehavior = .never
        navigationController?.hidesBarsOnSwipe = false
         
        navigationItem.backButtonTitle = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showMap":
            let destinationController = segue.destination as! MapViewController
            destinationController.restaurant = restaurnt
        case "showReview":
            let destinationController = segue.destination as! ReviewViewController
            destinationController.restaurant = restaurnt
        default: break
        }
        
    }
    
    @IBAction func favoriteAction(sender: UIButton){
        restaurnt.isFavorite = restaurnt.isFavorite ? false : true
        let heartImage = restaurnt.isFavorite ? "heart.fill" : "heart"
        headerView.heartButton.tintColor = restaurnt.isFavorite ? .systemYellow : .white
        headerView.heartButton.setImage(UIImage(systemName: heartImage), for: .normal)
    }
    
}


extension RestaurantDetailViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
            cell.descriptionLabel.text = restaurnt.description
            cell.selectionStyle = .none
            
            return cell
        
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTwoColumnCell.self), for: indexPath) as! RestaurantDetailTwoColumnCell
            cell.column1TitleLabel.text = "Address"
            cell.column1TextLabel.text = restaurnt.location
            cell.column2TitleLabel.text = "Phone"
            cell.column2TextLabel.text = restaurnt.phone
            cell.selectionStyle = .none
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailMapCell.self), for: indexPath) as! RestaurantDetailMapCell
            
            cell.configure(location: restaurnt.location)
            cell.selectionStyle = .none
        
            return cell
            
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
    
}


