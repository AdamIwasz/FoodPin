//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by Adam Iwaszkiewicz UCTI on 23/10/2022.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {

    var restaurant : [CKRecord] = []
    lazy var dataSource = configureDataSource()
    
    var spinner = UIActivityIndicatorView()
    
    private var imageCache = NSCache<CKRecord.ID, NSURL>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Customize the navigation bar appearance
        if let appearance = navigationController?.navigationBar.standardAppearance{
            appearance.configureWithTransparentBackground()
            
            if let customFont = UIFont(name: "Nunito-Bold", size: 45.0){
                appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
            }
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            
        }
        
        // Customize the spinner
        spinner.style = .medium
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        
        // Define layout constraints for the spinner
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0), spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        // Activate the spinner
        spinner.startAnimating()
        
        // Pull To Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: UIControl.Event.valueChanged)
        
        // Fetch record from iCloud
        fetchRecordsFromCloud()
        
        // Set the data source of the table view for Diffable Data Source
        tableView.dataSource = dataSource
        
    }

    // MARK: - Table view data source
    func configureDataSource() -> UITableViewDiffableDataSource<Section, CKRecord>{
        let cellIdentifier = "discovercell"
        
        let dataSource = UITableViewDiffableDataSource<Section, CKRecord>(tableView: tableView) { (tableView, IndexPath, restaurant) -> UITableViewCell? in
            let cell  = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: IndexPath) as! DiscoverTableViewCell
            
            cell.nameLabel?.text = restaurant.object(forKey: "name") as? String
            cell.locationLabel?.text = restaurant.object(forKey: "location") as? String
            cell.typeLabel?.text = restaurant.object(forKey: "type") as? String
            cell.descriptionLabel?.text = restaurant.object(forKey: "description") as? String
            
            // Set the default image
            cell.thumbnailImageView?.image = UIImage(systemName: "photo")
            cell.thumbnailImageView?.tintColor = .black
            
            // Check if the image is stored in cache
            if let imageFileURL = self.imageCache.object(forKey: restaurant.recordID) {
                // Fetch image from cache
                print("Get image from cache")
                if let imageData = try? Data.init(contentsOf: imageFileURL as URL){
                    cell.thumbnailImageView?.image = UIImage(data: imageData)
                }
            }else{
                
                // Fetch Image from Cloud in background
                let publicDatabase = CKContainer.default().publicCloudDatabase
                let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
                fetchRecordsImageOperation.desiredKeys = ["image"]
                fetchRecordsImageOperation.queuePriority = .veryHigh
                
                fetchRecordsImageOperation.perRecordResultBlock = {
                    (recordID, result) in
                    do{
                        let restaurantRecord = try result.get()
                        if let image = restaurantRecord.object(forKey: "image"), let imageAsset = image as? CKAsset{
                            if let imageData = try?
                                Data.init(contentsOf: imageAsset.fileURL!){
                                // Replace the placeholder image with the restaurant image
                                DispatchQueue.main.async {
                                    cell.thumbnailImageView?.image = UIImage(data: imageData)
                                    cell.setNeedsLayout()
                                }
                                // Add the image URL to cache
                                self.imageCache.setObject(imageAsset.fileURL! as NSURL, forKey: restaurant.recordID)
                            }
                        }
                } catch{
                    print("Failed to get restaurant image: \(error.localizedDescription)")
                }
            }
            publicDatabase.add(fetchRecordsImageOperation)
        }
            return cell
        }
        return dataSource
    }
    
    
    @objc func fetchRecordsFromCloud() {
        // Fetch data using Convenience API
        let cloudContainer = CKContainer.default()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        // Create the query operation with the query
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name", "location", "type", "description"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordMatchedBlock = { (recordID, result) -> Void in
            do {
                if let _ = self.restaurant.first(where: {$0.recordID == recordID}){
                    return
                }
                self.restaurant.append(try result.get())
            } catch {
                print(error)
            }
            
        }
        
//        queryOperation.queryResultBlock = { result in
//            switch result {
//            case .failure(let error):
//                print("Failed to get data from iCloud - \(error.localizedDescription)")
//                break
//            case .success():
//                print("Successfully retrieve the data from iCloud")
//
//                self.updateSnapshot()
//                DispatchQueue.main.async {
//                    self.spinner.stopAnimating()
//                    if let refreshControl = self.refreshControl{
//                        if refreshControl.isRefreshing{
//                            refreshControl.endRefreshing()
//                        }
//                    }
//                }
//                break
//            default:
//                break
//            }
//        }
        
        queryOperation.queryCompletionBlock = { [unowned self] (cursor, error) -> Void in
            if let error = error{
                print("Failed to get data from iCloud - \(error.localizedDescription)")
                return
            }

            print("Successfully retrieve the data from iCloud")
            
            self.updateSnapshot()
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                if let refreshControl = self.refreshControl{
                    if refreshControl.isRefreshing{
                        refreshControl.endRefreshing()
                    }
                }
            }
    
        }
        
        // Execute the query
        
        publicDatabase.add(queryOperation)
        
    }
    
    
    func updateSnapshot(animatingChange: Bool = false){
        // Create a snapshot and populate the data
        var snapshot = NSDiffableDataSourceSnapshot<Section, CKRecord>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurant, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    

}
