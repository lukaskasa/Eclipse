//
//  LocationManager.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 23.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit
import CoreLocation

/// Enum representing a LocationError
enum LocationError: Error {
    case unknownError
    case disallowedByUser
    case unableToFindLocation
    case locationServicesUnavailable
    
    var localizedDescription: String {
        switch self {
        case .unknownError:
            return "Error: Unknown error occured."
        case .disallowedByUser:
            return "Location Services where dissallowded. Change it in the settings."
        case .unableToFindLocation:
            return "It was not possible to retrieve the location."
        case .locationServicesUnavailable:
            return "Location servies are unavailable."
        }
        
    }
}

/// Delegate Protocol implemented by a Controller handling the retrieved Coordinates
protocol LocationManagerDelegate: class {
    func obtainedCoordinates(_ coordinate: Coordinate)
    func failedWithError(_ error: LocationError)
}

/// LocationManager to handler permission request and delegate methods used to retrieve users current location
class LocationManager: NSObject, CLLocationManagerDelegate {
    
   // MARK: - Properties
    private let locationManager = CLLocationManager()
    var viewController: UIViewController?
    /// Delegate
    weak var delegate: LocationManagerDelegate?
    
    /// Computed property to get location services authorization
    var isAuthorized: Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            return true
        default:
            return false
        }
    }
    
    /**
     Initializes manager to handle Location based functionality
     
     - Parameters:
        - delegate: The delegate to handle location
        - viewController: The view controller used to handle alerts and authorization requests
     
     - Returns: A manager for location services
     */
    init(delegate: LocationManagerDelegate?, viewController: UIViewController?) {
        self.delegate = delegate
        self.viewController = viewController
        super.init()
        locationManager.delegate = self
    }
    
    /**
     Requests the Location Authorization
     
     - Throws: 'LocationError.disallowedByUser' - if location services are dissallowed by the user
     'LocationError.locationServicesUnavailable' if location servies are not available
     
     - Returns: Void
     */
    func requestLocationAuthorization() throws {
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        let locationServicesEnabled = CLLocationManager.locationServicesEnabled()
        
        if locationServicesEnabled {
            if authorizationStatus == .restricted || authorizationStatus == .denied {
                throw LocationError.disallowedByUser
            } else if authorizationStatus == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            } else {
                return
            }
        } else {
            throw LocationError.locationServicesUnavailable
        }

    }
    
    /// Requests the current user location
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    // MARK: - Delegate Methods
    /// Apple documentation: https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate
    
    /// Tells the delegate that the authorization status for the application changed.
    /// Apple documentation: https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate/1423701-locationmanager
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            requestLocation()
        }
    }
    
    /// Tells the delegate that the location manager was unable to retrieve a location value.
    /// Apple documentation: https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate/1423786-locationmanager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        guard let error = error as? CLError else {
            return
        }
        
        switch error.code {
        case .locationUnknown, .network:
            delegate?.failedWithError(.unableToFindLocation)
        case .denied:
            delegate?.failedWithError(.disallowedByUser)
        default:
            return
        }
    }
    
    /// Tells the delegate that new location data is available.
    /// Apple documentation: https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate/1423615-locationmanager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            delegate?.failedWithError(.unableToFindLocation)
            return
        }
        
        let coordinate = Coordinate(with: location)
        
        delegate?.obtainedCoordinates(coordinate)
    }
    
    
}
