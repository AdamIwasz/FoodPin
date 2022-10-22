//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Adam Iwaszkiewicz UCTI on 16/09/2022.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController {

    
    // MARK: Initializing restaurants
    var fetchResultController: NSFetchedResultsController<Restaurant>!
    var restaurants: [Restaurant] = []
    var searchController: UISearchController!
    
    @IBOutlet var emptyRestaurantView: UIView!
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    lazy var dataSource = configureDataSource()
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRestaurantData()
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.dataSource = dataSource
        
        // Set lack of separator between tableView cells
        tableView.separatorStyle = .none
        
        // Customization of navigationBar
        if let apperance = navigationController?.navigationBar.standardAppearance{
            apperance.configureWithTransparentBackground()
            
            if let customFont = UIFont(name: "Nunito-Bold", size: 45.0) {
                apperance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!]
                apperance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
            }
            
            navigationController?.navigationBar.standardAppearance = apperance
            navigationController?.navigationBar.compactAppearance = apperance
            navigationController?.navigationBar.scrollEdgeAppearance = apperance
            
        }
        // Set prefersLargeTitles to true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.backButtonTitle = ""
        navigationController?.hidesBarsOnSwipe = true
        
        // prepare the empty view
        tableView.backgroundView = emptyRestaurantView
        tableView.backgroundView?.isHidden = restaurants.count == 0 ? false : true
        
        // search bar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search restaurants..."
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = UIColor(named: "NavigationBarTitle")
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    // MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        // MARK: Check for welcome screen to apear
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough"){
            return
        }
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController{
            present(walkthroughViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.hidesBarsOnSwipe = true
    
    }
    //MARK: Configurate swipe left actions
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        // get the selected restaurant
        guard let restaurant = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        // Check if search bar is active then disable all swipe actions
        if searchController.isActive{
            return UISwipeActionsConfiguration()
        }
        
        // Delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                let context = appDelegate.persistentContainer.viewContext
                
                //delete the item
                context.delete(restaurant)
                appDelegate.saveContext()
                
                //update view
                
                self.updateSnapshot(animatingChange: true)
            }
            completionHandler(true)
        }
        
        // Share action
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
            let defaultText = "Just check in at " + restaurant.name
            
            let activityController : UIActivityViewController
            
            if let imageToShare = UIImage(data: restaurant.image){
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            } else {
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            // Popover for iPad
            if let popoverControler = activityController.popoverPresentationController{
                if let cell = tableView.cellForRow(at: indexPath){
                    popoverControler.sourceView = cell
                    popoverControler.sourceRect = cell.bounds
                }
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
    
    // MARK: Configurate swipe right actions
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Check if search bar is active then disable all swipe actions
        if searchController.isActive{
            return UISwipeActionsConfiguration()
        }
        
        //favoriteAction
        let favoriteAction = UIContextualAction(style: .normal, title: ""){
            (action, sourceView, completionHandler) in
            
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
            
            cell.heartImageView.isHidden = self.restaurants[indexPath.row].isFavorite
            
            self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false : true
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                appDelegate.saveContext()
            }
            
            completionHandler(true)
        }
        
        favoriteAction.backgroundColor = UIColor.systemIndigo
        favoriteAction.image = self.restaurants[indexPath.row].isFavorite ? UIImage(systemName: "heart.slash.fill") : UIImage(systemName: "heart.fill")
        
        let swipeAction = UISwipeActionsConfiguration(actions: [favoriteAction])
        
        return swipeAction
        
    }
    
    //MARK: Configurate seague
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail"{
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationControler = segue.destination as! RestaurantDetailViewController
                destinationControler.restaurnt = restaurants[indexPath.row]
                searchController.isActive = false
            }
        }
    }
    // MARK: Configurate data source
    func configureDataSource() -> RestaurantDiffableDataSource {

        let cellIdentifier = "datacell"

        let dataSource = RestaurantDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, restaurant in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell

                cell.nameLabel.text = self.restaurants[indexPath.row].name
                cell.locationLabel.text = self.restaurants[indexPath.row].location
                cell.typeLabel.text = self.restaurants[indexPath.row].type
                cell.thumbnailImageView.image = UIImage(data: self.restaurants[indexPath.row].image)
                cell.heartImageView.isHidden = self.restaurants[indexPath.row].isFavorite ? false : true

                return cell
            }
        )

        return dataSource
    }
    
    // MARK: Fetch restaurant data
    func fetchRestaurantData(searchText: String = ""){
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        
        if !searchText.isEmpty{
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@ or location CONTAINS[c] %@", searchText, searchText)
        }
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                updateSnapshot(animatingChange: searchText.isEmpty ? false : true)
            }catch{
                print(error)
            }
        }
    }
    
    func updateSnapshot(animatingChange: Bool = false){
        if let fetchedObjects = fetchResultController.fetchedObjects{
            restaurants = fetchedObjects
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
        
        tableView.backgroundView?.isHidden = restaurants.count == 0 ? false : true
    }
    
}

extension RestaurantTableViewController: NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot()
    }
}

extension RestaurantTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text
        else{
            return
        }
        fetchRestaurantData(searchText: searchText)
    }
}
