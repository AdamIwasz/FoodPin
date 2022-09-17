//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Adam Iwaszkiewicz UCTI on 16/09/2022.
//

import UIKit

class RestaurantTableViewController: UITableViewController {

    var restaurantNames = ["Cafe Deadend", "Homei", "Teakha", "Cafe Loisl", "Petite Oyster", "For Kee Restaurant", "Po's Atelier", "Bourke Street Bakery", "Haigh's Chocolate", "Palomino Espresso", "Upstate", "Traif", "Graham Avenue Meats", "Waffle & Wolf", "Five Leaves", "Cafe Lore", "Confessional", "Barrafina", "Donostia", "Royal Oak", "CASK Pub and Kitchen"]
    
    var restaurantImages = ["cafedeadend", "homei", "teakha", "cafeloisl", "petiteoyster", "forkee", "posatelier", "bourkestreetbakery", "haigh", "palomino", "upstate", "traif", "graham", "waffleandwolf", "fiveleaves", "cafelore", "confessional", "barrafina", "donostia", "royaloak", "cask"]
    
    var restaurantLocations = ["Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Sydney", "Sydney", "Sydney", "New York", "New York", "New York", "New York", "New York", "New York", "New York", "London", "London", "London", "London"]
    
    var restaurantTypes = ["Coffee & Tea Shop", "Cafe", "Tea House", "Austrian / Causual Drink", "French", "Bakery", "Bakery", "Chocolate", "Cafe", "American / Seafood", "American", "American", "Breakfast & Brunch", "Coffee & Tea", "Coffee & Tea", "Latin American", "Spanish", "Spanish", "Spanish", "British", "Thai"]
    
    var restaurantIsFavourite = Array(repeating: false, count: 21)
    
    lazy var dataSource = configurateDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.dataSource = dataSource
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurantNames, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)
        tableView.separatorStyle = .none
    }
    
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
        let favoriteAction = UIAlertAction(title: "Mark as favorite", style: .default, handler: { (action:UIAlertAction!) -> Void in
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
//            cell?.accessoryType = .checkmark
            cell.heartImageView.isHidden = false
            
            self.restaurantIsFavourite[indexPath.row] = true
        })
        
        // add "remove from favorite" action
        let removeFromFavoriteAction = UIAlertAction(title: "Remove from favorites", style: .default, handler: { (action:UIAlertAction!) -> Void in
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
            //cell?.accessoryType = .none
            cell.heartImageView.isHidden = true
            self.restaurantIsFavourite[indexPath.row] = false
        })
        
        optionMenu.addAction(self.restaurantIsFavourite[indexPath.row] ? removeFromFavoriteAction : favoriteAction)
        
//        optionMenu.addAction(favoriteAction)
        // display the menu
        present(optionMenu, animated: true, completion: nil)
        // deselect the row
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    enum Section {
        case all
    }
    
    func configurateDataSource() -> UITableViewDiffableDataSource<Section, String>{
//        let cellIdentifier = "datacell"
        let cellIdentifier = "favoritecell"
        
        let dataSource = UITableViewDiffableDataSource<Section,String>(
            tableView: tableView,
            cellProvider: {tableView, indexPath, restaurantName in let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
            
                cell.nameLabel.text = restaurantName
                cell.locationLabel.text = self.restaurantLocations[indexPath.row]
                cell.typeLabel.text = self.restaurantTypes[indexPath.row]
                cell.thumbnailImageView.image = UIImage(named: self.restaurantImages[indexPath.row])
                //cell.accessoryType = self.restaurantIsFavourite[indexPath.row] ? .checkmark : .none
                cell.heartImageView.isHidden = self.restaurantIsFavourite[indexPath.row] ? false : true
                
            return cell
        }
        )
        
        return dataSource
    }
}
