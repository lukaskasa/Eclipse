//
//  LocationSearchController.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 13.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch: class {
    func dropInZoom(placemark: MKPlacemark)
}

protocol Dismissable: class {
    func dismissSearch() -> Void
}

class LocationSearchController: UITableViewController {
    
    // MARK: - Constants
    private let locationResultCellReuseIdentifier = "LocationResultCell"
    private let currentLocationCellHeight: CGFloat = 44.0
    private let seachResultsCellHeight: CGFloat = 50.0
    private let topMarginPortrait: CGFloat = 100.0
    private let topMarginLandscape: CGFloat = 88.0
    
    var locationSearchResults = [MKMapItem]()
    var mapView: MKMapView?

    weak var handleMapSearchDelegate: HandleMapSearch?
    weak var dismissableDelegate: Dismissable?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup
        tableView.backgroundColor = .clear
        view.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if UIDevice.current.orientation.isLandscape {
            configureView(topMargin: topMarginLandscape)
        } else {
            configureView(topMargin: topMarginPortrait)
        }
    }
    
    // MARK: - Helper
    
    func configureView(topMargin: CGFloat) {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        tableView.backgroundColor = .black
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.frame = CGRect(x: 0, y: topMargin, width: screenWidth, height: screenHeight)
    }
    
}

extension LocationSearchController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismissableDelegate?.dismissSearch()
        searchBar.isHidden = true
    }
    
}

// MARK: - UITableViewDatasource & UITableViewDelegate implementation
extension LocationSearchController {
    
    // MARK: - Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return locationSearchResults.count
        }
        return 1
    }
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let selectedItem = locationSearchResults[indexPath.row].placemark
            handleMapSearchDelegate?.dropInZoom(placemark: selectedItem)
        } else {
            if let userLocationCoordinate = mapView?.userLocation.coordinate {
                let selectedItem = MKPlacemark(coordinate: userLocationCoordinate)
                handleMapSearchDelegate?.dropInZoom(placemark: selectedItem)
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
