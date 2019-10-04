//
//  Coordinate.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 23.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import CoreLocation

/// Struct representing a geographical coordinate consisting of a latitude and longitude
struct Coordinate {
    let latitude: Double
    let longitude: Double
}

extension Coordinate {
    
    /// Initalizer implementation which takes a CLLocation and extracts the latitude and longitude from it
    /// Returns a Coordinate object
    init(with location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
    
}
