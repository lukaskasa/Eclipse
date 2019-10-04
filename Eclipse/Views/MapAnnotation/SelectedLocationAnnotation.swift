//
//  SelectedLocationAnnotation.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 22.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import MapKit

/// The custom annotation used to display for every location search by the user
class SelectedLocationAnnotation: NSObject, MKAnnotation {
    
    /// Properties
    var place: MKPlacemark
    var coordinate: CLLocationCoordinate2D { return place.coordinate }
    
    /**
     Initializes a SelectedLocationAnnotation
     
     - Returns: A SelectedLocationAnnotation
     */
    init(place: MKPlacemark) {
        self.place = place
        super.init()
    }
    
    var title: String? {
        return place.title
    }
    
}
