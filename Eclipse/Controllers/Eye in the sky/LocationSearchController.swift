//
//  LocationSearchController.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 13.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/// Protocol to be implented to handle the map search
protocol HandleMapSearch: class {
    func dropInZoom(placemark: MKPlacemark)
}

/// Protocol to be implemented to dismiss a search
protocol Dismissable: class {
    func dismissSearch(_ force: Bool) -> Void
}

/// LocationSearchController to handle location search results
class LocationSearchController: UITableViewController {
    
    // MARK: - Constants
    private let locationResultCellReuseIdentifier = "LocationResultCell"
    private let currentLocationCellHeight: CGFloat = 44.0
    private let seachResultsCellHeight: CGFloat = 50.0
    /// Computed property determining the margin depending on iOS version
    private var topMarginPortrait: CGFloat {
        if #available(iOS 13, *) {
            return 112.0
        } else {
            return 100.0
        }
    }
    let geocoder = CLGeocoder()
    var locationSearchResults = [MKMapItem]()
    var mapView: MKMapView?

    /// Delegate protocols
    weak var handleMapSearchDelegate: HandleMapSearch?
    weak var dismissableDelegate: Dismissable?
    
    // Hide Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup
        tableView.backgroundColor = .clear
        view.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureView(topMargin: topMarginPortrait)
    }
    
    // MARK: - Helper
    
    /// Configures the view
    func configureView(topMargin: CGFloat) {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        tableView.backgroundColor = .black
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.frame = CGRect(x: 0, y: topMargin, width: screenWidth, height: screenHeight)
    }

}

// MARK: - UISearchResultsUpdating & UISearchBarDelegate implementation
/// - Apple documentation:
/// UISearchResultsUpdating - https://developer.apple.com/documentation/uikit/uisearchresultsupdating
/// UISearchBarDelegate - https://developer.apple.com/documentation/uikit/uisearchbardelegate
extension LocationSearchController: UISearchResultsUpdating, UISearchBarDelegate {
    
    /// Called when the search bar becomes the first responder or when the user makes changes inside the search bar.
    /// Apple documentation: https://developer.apple.com/documentation/uikit/uisearchresultsupdating/1618658-updatesearchresults
    func updateSearchResults(for searchController: UISearchController) {
        tableView.isHidden = false
        
        guard let mapView = mapView, let searchTerm = searchController.searchBar.text else {
            return
            
        }
        
        if !searchTerm.isEmpty {
            // Configure search request
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchTerm
            request.region = mapView.region
            
            let search = MKLocalSearch(request: request)
            search.start { response, error in
                
                guard let response = response else { return }
                
                self.locationSearchResults = response.mapItems
                self.tableView.reloadData()
                
                if error != nil {
                    print(error!.localizedDescription)
                }
                
            }
            
        }
        
    }
    
    /// Tells the delegate that the cancel button was tapped.
    /// Apple documentation: https://developer.apple.com/documentation/uikit/uisearchbardelegate/1624314-searchbarcancelbuttonclicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissableDelegate?.dismissSearch(false)
    }
    
}

// MARK: - UITableViewDatasource & UITableViewDelegate implementation
/// Apple documentation:
/// UITableViewDatasource - https://developer.apple.com/documentation/uikit/uitableviewdatasource
/// UITableViewDelegate - https://developer.apple.com/documentation/uikit/uitableviewdelegate
extension LocationSearchController {
    
    // MARK: - Delegate
    
    /// Asks the data source to return the number of sections in the table view.
    /// Apple documentation: https://developer.apple.com/documentation/uikit/uitableviewdatasource/1614860-numberofsections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /// Tells the data source to return the number of rows in a given section of a table view.
    /// Apple documentation: https://developer.apple.com/documentation/uikit/uitableviewdatasource/1614931-tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return locationSearchResults.count
        }
        return 1
    }
    
    /// Asks the data source for a cell to insert in a particular location of the table view.
    /// Apple documentation: https://developer.apple.com/documentation/uikit/uitableviewdatasource/1614861-tableview
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CurrentLocationCell.reuseIdentifier, for: indexPath) as! CurrentLocationCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: locationResultCellReuseIdentifier, for: indexPath)
            
            let selectedItem = locationSearchResults[indexPath.row].placemark
            cell.textLabel?.text = selectedItem.name
            cell.detailTextLabel?.text = selectedItem.parseAddress()
            
            return cell
        }
        
    }
    
    /// Tells the delegate that the specified row is now selected.
    /// Apple documentation: https://developer.apple.com/documentation/uikit/uitableviewdelegate/1614877-tableview
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let selectedItem = locationSearchResults[indexPath.row].placemark
            handleMapSearchDelegate?.dropInZoom(placemark: selectedItem)
        } else {
            
            if let userLocation = mapView?.userLocation.location {
                
                geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    // Most geocoding requests contain only one result.
                    if let firstPlacemark = placemarks?.first {
                        let userPlacemark = MKPlacemark(placemark: firstPlacemark)
                        self.handleMapSearchDelegate?.dropInZoom(placemark: userPlacemark)
                    }
                }
                
            }

            

        }
        
        dismiss(animated: true, completion: nil)
    }
    
    /// Asks the delegate for the height to use for a row in a specified location.
    /// https://developer.apple.com/documentation/uikit/uitableviewdelegate/1614998-tableview
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return currentLocationCellHeight
        }
        
        return seachResultsCellHeight
    }
    
    
}
