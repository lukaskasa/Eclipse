//
//  EarthViewController.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 13.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit
import MapKit

class EarthViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
//    lazy var earthImageView: EarthImageView = {
//        return Bundle.main.loadNibNamed(String(describing: EarthImageView.self), owner: self, options: nil)?.first as! EarthImageView
//    }()
//
//    lazy var locationDetailView: LocationDetailConfigView? = {
//        return Bundle.main.loadNibNamed(String(describing: LocationDetailConfigView.self), owner: self, options: nil)?.first as! LocationDetailConfigView
//    }()
    
    var sateliteImage: UIImage!
    let nasaClient = NASAClient()
    var navigationBar: UINavigationBar!
    var searchBar: UISearchBar!
    var searchView: UIView!
    var navItem = UINavigationItem(title: "Eye in the Sky")
    var locationSearchController: LocationSearchController?
    
    struct Constants {
        static let darkGrey = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        static let searchPlaceholder = "Search for a location"
    }
    
    struct BarButtons {
        static let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close))
        
        static let backButton = UIBarButtonItem(image: UIImage(named: "back"), landscapeImagePhone: UIImage(named: "back"), style: .done, target: self, action: #selector(close))
        
        static let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
    }
    
    lazy var searchController: UISearchController = {
        return UISearchController(searchResultsController: locationSearchController)
    }()
    
    // MARK - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup
        title = "Eye in the sky"
        setDelegates()
        setupNavigationBar()
        setupMap()

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Helper
    
    func setDelegates() {
        locationSearchController = (storyboard!.instantiateViewController(withIdentifier: String(describing: LocationSearchController.self)) as! LocationSearchController)
        searchController.searchBar.delegate = locationSearchController
        searchController.searchResultsUpdater = locationSearchController
        mapView.delegate = self
        locationSearchController?.dismissableDelegate = self
        locationSearchController?.handleMapSearchDelegate = self
    }
    
    func setupNavigationBar() {
        
        let screenWidth = UIScreen.main.bounds.width
        let rect = CGRect(x: 0, y: 0, width: screenWidth, height: 44)
        navigationBar = UINavigationBar(frame: rect)

        
        navItem.leftBarButtonItem = BarButtons.backButton
        navItem.rightBarButtonItem = BarButtons.searchButton
        
        navigationBar.barStyle = .black
        navigationBar.backgroundColor = Constants.darkGrey
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .white
        navigationBar.setItems([navItem], animated: true)
        
        view.addSubview(navigationBar)
        setupSearchBar()
    }
    
    func setupSearchBar() {
        
        locationSearchController?.mapView = mapView
        
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        navItem.searchController = searchController
        searchBar = searchController.searchBar
        
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44.0)
        
        searchView = UIView(frame: rect)
        searchView.backgroundColor = .clear
        
        view.addSubview(searchView)
        
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 0).isActive = true
        searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true

        searchBar.isHidden = true
        searchBar.placeholder = Constants.searchPlaceholder
        searchBar.barStyle = .black
        searchBar.barTintColor = .black
        searchBar.isTranslucent = true
        searchBar.tintColor = .white
        
        searchView.addSubview(searchBar)
    }
    
    func setupMap() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
    }
    
    @objc func search() {
        navItem.leftBarButtonItem = BarButtons.closeButton
        searchBar.becomeFirstResponder()
        searchBar.isHidden = false
    }
    
    @objc func close() {
        dismissSearch()
        dismiss(animated: true, completion: nil)
    }
    
}

extension EarthViewController: Dismissable {
    
    func dismissSearch() {
        navItem.leftBarButtonItem = BarButtons.backButton
        searchBar.resignFirstResponder()
        searchBar.isHidden = true
    }
    
}

extension EarthViewController: HandleMapSearch {
    
    func dropInZoom(placemark: MKPlacemark) {
        
        dismissSearch()
        
        let annotation = SelectedLocationAnnotation(place: placemark)
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)

        mapView.selectAnnotation(annotation, animated: true)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
}

extension EarthViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let visibleLocation = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(visibleLocation, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "SearchedLocation")
        
        if annotationView == nil {
            
            annotationView = SelectedLocationAnnotationView(annotation: annotation, reuseIdentifier: "SearchedLocation")
            // Set Delegate
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
        
    }
    
}
