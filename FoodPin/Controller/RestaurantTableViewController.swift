//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Adam Iwaszkiewicz UCTI on 16/09/2022.
//

import UIKit

class RestaurantTableViewController: UITableViewController {

    
    // MARK: Initializing restaurants
    var restaurants:[Restaurant] = [
        Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "Hong Kong", image: "cafedeadend", isFavorite: false),
        Restaurant(name: "Homei", type: "Cafe", location: "Hong Kong", image: "homei", isFavorite: false),
        Restaurant(name: "Teakha", type: "Tea House", location: "Hong Kong", image: "teakha", isFavorite: false),
        Restaurant(name: "Cafe loisl", type: "Austrian / Causual Drink", location: "Hong Kong", image: "cafeloisl", isFavorite: false),
        Restaurant(name: "Petite Oyster", type: "French", location: "Hong Kong", image: "petiteoyster", isFavorite: false),
        Restaurant(name: "For Kee Restaurant", type: "Bakery", location: "Hong Kong", image: "forkee", isFavorite: false),
        Restaurant(name: "Po's Atelier", type: "Bakery", location: "Hong Kong", image: "posatelier", isFavorite: false),
        Restaurant(name: "Bourke Street Backery", type: "Chocolate", location: "Sydney", image: "bourkestreetbakery", isFavorite: false),
        Restaurant(name: "Haigh's Chocolate", type: "Cafe", location: "Sydney", image: "haigh", isFavorite: false),
        Restaurant(name: "Palomino Espresso", type: "American / Seafood", location: "Sydney", image: "palomino", isFavorite: false),
        Restaurant(name: "Upstate", type: "American", location: "New York", image: "upstate", isFavorite: false),
        Restaurant(name: "Traif", type: "American", location: "New York", image: "traif", isFavorite: false),
        Restaurant(name: "Graham Avenue Meats", type: "Breakfast & Brunch", location: "New York", image: "graham", isFavorite: false),
        Restaurant(name: "Waffle & Wolf", type: "Coffee & Tea", location: "New York", image: "waffleandwolf", isFavorite: false),
        Restaurant(name: "Five Leaves", type: "Coffee & Tea", location: "New York", image: "fiveleaves", isFavorite: false),
        Restaurant(name: "Cafe Lore", type: "Latin American", location: "New York", image: "cafelore", isFavorite: false),
        Restaurant(name: "Confessional", type: "Spanish", location: "New York", image: "confessional", isFavorite: false),
        Restaurant(name: "Barrafina", type: "Spanish", location: "London", image: "barrafina", isFavorite: false),
        Restaurant(name: "Donostia", type: "Spanish", location: "London", image: "donostia", isFavorite: false),
        Restaurant(name: "Royal Oak", type: "British", location: "London", image: "royaloak", isFavorite: false),
        Restaurant(name: "CASK Pub and Kitchen", type: "Thai", location: "London", image: "cask", isFavorite: false)
    ]
    
    lazy var dataSource = configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.dataSource = dataSource
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)
        tableView.separatorStyle = .none
    }
    
    // MARK: Actions for didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // create option menu
        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        if let popoverController = optionMenu.popoverPresentationController{
            if let cell = tableView.cellForRow(at: indexPath){
                popoverController.sourceView = cell
                popoverController.sourceRect = cell.bounds
            }
        }
        
        // add actions to option menu
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        // add "reserve a table" action
        let reserveActionHendler = { (action:UIAlertAction!) -> Void in
            let alertMessange = UIAlertController(title: "Not available yet", message: "Sorry, this feature is not available yet. Please retry later.", preferredStyle: .alert)
            alertMessange.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessange, animated: true, completion: nil)
        }
        let reserveAction = UIAlertAction(title: "Reserve a table", style: .default, handler: reserveActionHendler)
        optionMenu.addAction(reserveAction)
        
        //Add "add to favorite" action
        //Chceck if restaurant is already favorite
        let favoriteActionTitle = self.restaurants[indexPath.row].isFavorite ? "Remove from favorites" : "Mark as favorite"
        let favoriteAction = UIAlertAction(title: favoriteActionTitle, style: .default, handler: { (action:UIAlertAction!) -> Void in
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
            
            cell.heartImageView.isHidden = self.restaurants[indexPath.row].isFavorite
            
            self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false : true
            
            //cell.accessoryType = self.restaurants[indexPath.row].isFavorite ? .checkmark : .none
        })
        
        optionMenu.addAction(favoriteAction)
        // display the menu
        present(optionMenu, animated: true, completion: nil)
        // deselect the row
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //MARK: Configurate swipe left actions
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        // get the selected restaurant
        guard let restaurant = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        // Delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([restaurant])
            self.dataSource.apply(snapshot, animatingDifferences: true)
            
            completionHandler(true)
        }
        
        // Share action
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
            let defaultText = "Just check in at " + restaurant.name
            
            let activityController : UIActivityViewController
            
            if let imageToShare = UIImage(named: restaurant.image){
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            } else {
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            self.present(activityController, animated: true, completion: nil)
            
            completionHandler(true)
        }
        
        // Delete action button customization
        deleteAction.backgroundColor = UIColor.systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        // Share action button cutomization
        shareAction.backgroundColor = UIColor.systemOrange
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        // configure both action as swipe action
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return swipeConfiguration
    }
    
    
    // MARK: Configurate data source
    func configureDataSource() -> RestaurantDiffableDataSource {

        let cellIdentifier = "datacell"

        let dataSource = RestaurantDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, restaurant in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell

                cell.nameLabel.text = restaurant.name
                cell.locationLabel.text = restaurant.location
                cell.typeLabel.text = restaurant.type
                cell.thumbnailImageView.image = UIImage(named: restaurant.image)
                cell.heartImageView.isHidden = restaurant.isFavorite ? false : true

                return cell
            }
        )

        return dataSource
    }
}
