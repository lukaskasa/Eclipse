//
//  EarthViewController.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 13.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit
import MapKit

/// UIViewController for the Eye in the Sky module
class EarthViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    private let modalViewTag = 10
    private let darkenViewTag = 20
    private let darkGrey = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
    private let searchPlaceholder = "Search for a location"
    
    let client = NASAClient()
    var sateliteImage: UIImage!
    var annotationView: MKAnnotationView?
    var navigationBar: NavigationBar?
    var searchBar: UISearchBar!
    var searchView: UIView!
    var locationSearchController: LocationSearchController?
    var loadAnimation: LoadAnimation?
    
    lazy var locationManager: LocationManager = {
        return LocationManager(delegate: self, viewController: self)
    }()
    
    lazy var searchController: UISearchController = {
        return UISearchController(searchResultsController: locationSearchController)
    }()
    
    // MARK - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup
        setDelegates()
        setupNavigationBar()
        setupMap()
    }
    
    // TODO: Remove?
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Helper
    
    /// Sets all the delegates
    func setDelegates() {
        locationSearchController = (storyboard!.instantiateViewController(withIdentifier: String(describing: LocationSearchController.self)) as! LocationSearchController)
        searchController.searchBar.delegate = locationSearchController
        searchController.searchResultsUpdater = locationSearchController
        mapView.delegate = self
        locationSearchController?.dismissableDelegate = self
        locationSearchController?.handleMapSearchDelegate = self
    }
    
    /// Sets up the navigation bar with a search bar
    func setupNavigationBar() {
        navigationBar = NavigationBar(for: self.view, title: "Eye in the sky", leftButton: .back, rightButton: .search, leftButtonAction: #selector(mainMenu), rightButtonAction: #selector(search))
        navigationBar?.load()
        setupSearchBar()
    }
    
    /// Setup method for the UISearchBar
    func setupSearchBar() {
        locationSearchController?.mapView = mapView
        definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false

        searchView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 56.0))
        searchView.backgroundColor = .clear
        searchView.isHidden = true
        
        // Add a blur effect to the searchView
        var blurStyle: UIBlurEffect.Style = .dark
        if #available(iOS 13, *) {
            blurStyle = .systemChromeMaterialDark
        }
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.frame = searchView.bounds
        searchView.addSubview(blurEffectView)

        view.addSubview(searchView)

        // Add constraints
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.topAnchor.constraint(equalTo: (navigationBar?.navBar.bottomAnchor)!, constant: 0).isActive = true
        searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        searchView.heightAnchor.constraint(equalToConstant: 56.0).isActive = true

        // Configure the search bar
        searchBar = searchController.searchBar
        searchBar.isHidden = true
        searchBar.placeholder = searchPlaceholder
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.tintColor = .white
        searchBar.barStyle = .black
        searchBar.isTranslucent = true

        searchView.addSubview(searchBar)
    }

    /// Configure the map
    func setupMap() {
        getLocation()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
    }
    
    /// Starts the NASA animation once an API call is trigged
    func startAnimation() {
        let dimView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        loadAnimation = LoadAnimation(for: self.view)
        
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        dimView.tag = 20
        view.addSubview(dimView)
        
        view.addSubview(loadAnimation!)

        loadAnimation?.translatesAutoresizingMaskIntoConstraints = false
        loadAnimation?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadAnimation?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        loadAnimation?.start()
    }
    
    /// @objc method that shows the searchfield on on screen
    @objc func search() {
        navigationBar?.navItem.leftBarButtonItem = NavBarButton.close.button(action: #selector(closeSearch))
        searchView.isHidden = false
        searchBar.isHidden = false
        searchBar.becomeFirstResponder()
    }
    
    /// Hides the searchfield
    @objc func closeSearch() {
        dismissSearch(true)
    }
    
    /// Navigate back to the search field
    @objc func mainMenu() {
        dismiss(animated: true, completion: nil)
    }
    
    /// Returns an action which fires an API call and sets the satelite image
    func action(place: MKPlacemark, annotation: MKAnnotationView) -> (() -> Void) {
        annotationView = annotation
        
        let action = { [weak self] in
            
            annotation.setSelected(false, animated: true)
            
            self?.startAnimation()
            annotation.isHidden = true
            
            guard let strongSelf = self else { return }
            
            strongSelf.client.getEarthImageData(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude) { data, error in
                
                DispatchQueue.main.async {
                    
                    let view = SateliteImageView()
                    
                    // Set cancel action of the modal
                    view.cancelAction = {
                        strongSelf.close()
                    }
                    
                    // Set save action of the modal
                    view.saveAction = {
                        
                        if let image = view.imageView.image {
                            UIImageWriteToSavedPhotosAlbum(image, self, #selector(strongSelf.image(_:didFinishSavingWithError:contextInfo:)), nil)
                            strongSelf.close()
                        }
                        

                    }
                    
                    if let data = data {
                        
                        strongSelf.client.getImage(earthImageJSON: data) { imageData, error in
                            
                            DispatchQueue.main.async {
                                
                                guard let imageData = imageData, let image = UIImage(data: imageData), let superview = strongSelf.view else { return }
                                view.imageView.image = image
                                view.tag = strongSelf.modalViewTag
                                
                                superview.addSubview(view)
                                
                                if let view = superview.viewWithTag(strongSelf.darkenViewTag) {
                                    self?.addClosingGestureTo(view: view)
                                }
                                
                                view.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
                                view.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
                                
                                annotation.isHidden = false
                                annotation.setSelected(false, animated: true)
                                self?.loadAnimation?.removeFromSuperview()
                            }
                            
                        }
                        
                        
                    }
                }
                
            }
            
        }
        
        return action
    }
    
    /// Adds a gesture recognizer which is used to close the modal
    func addClosingGestureTo(view: UIView) {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeModal))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    /// Closes the modal
    @objc func closeModal() {
        close()
    }
    
    /// Closes the modal by removed it from the superview
    func close() {
        let modalView = view.viewWithTag(modalViewTag)
        let darkenView = view.viewWithTag(darkenViewTag)
        modalView?.removeFromSuperview()
        darkenView?.removeFromSuperview()
        annotationView?.setSelected(true, animated: true)
    }
    
    /// @objc method to show an alert if there is an error while saving the photo
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(with: "Error", and: error.localizedDescription)
        } else {
            showAlert(with: "Saved", and: "The Satelite Image was saved!")
        }
    }
    
    
}

/// Implementation of LocationManagerDelegate
extension EarthViewController: LocationManagerDelegate {
    
    func obtainedCoordinates(_ coordinate: Coordinate) {
        /// Set current location
    }
    
    func failedWithError(_ error: LocationError) {
        showAlert(with: "Location Error", and: "Error while getting your location")
    }
    
    // MARK: - Helper
    
    ///
    func locationServicesAvailable() -> Bool {
        if !locationManager.isAuthorized {
            do {
                try locationManager.requestLocationAuthorization()
            } catch LocationError.disallowedByUser {
                showSettingsAlert(with: "No Access", and: "Please allow location services in the settings to proceed.")
            }
            catch LocationError.locationServicesUnavailable {
                showSettingsAlert(with: "Location services unavailable", and: "Please enable location services to use region monitoring.")
            } catch {
                fatalError()
            }
        } else {
            return true
        }
        
        return false
    }
    
    /// Request the current location
    func getLocation() {
        if locationServicesAvailable() {
            locationManager.requestLocation()
        }
    }
    
    
}

extension EarthViewController: Dismissable {
    
    func dismissSearch(_ force: Bool) {
        if force { dismiss(animated: true, completion: nil) }
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.isHidden = true
        searchView.isHidden = true
        navigationBar?.navItem.leftBarButtonItem = NavBarButton.back.button(action: #selector(mainMenu))
    }
    
}

/// HandleMapSearch Implementation to zoom into the map
extension EarthViewController: HandleMapSearch {
    
    func dropInZoom(placemark: MKPlacemark) {
        dismissSearch(false)
        
        let annotation = SelectedLocationAnnotation(place: placemark)
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}

/// Optional methods that you use to receive map-related update messages.
/// Apple documentation: https://developer.apple.com/documentation/mapkit/mkmapviewdelegate
extension EarthViewController: MKMapViewDelegate {
    
    /// Tells the delegate that the location of the user was updated.
    /// Apple documentation: https://developer.apple.com/documentation/mapkit/mkmapviewdelegate/1452086-mapview
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let visibleLocation = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(visibleLocation, animated: true)
    }
    
    /// Returns the view associated with the specified annotation object.
    /// Apple documentation: https://developer.apple.com/documentation/mapkit/mkmapviewdelegate/1452045-mapviews
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "SearchedLocation")
        
        if annotationView == nil {
            
            annotationView = SelectedLocationAnnotationView(annotation: annotation, reuseIdentifier: "SearchedLocation", actionDelegate: self)
            // Set Delegate
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
        
    }
    
}
