//
//  SelectedLocationAnnotation.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 22.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import MapKit

class SelectedLocationAnnotation: NSObject, MKAnnotation {
    
    var place: MKPlacemark
    var coordinate: CLLocationCoordinate2D { return place.coordinate }
    
    init(place: MKPlacemark) {
        self.place = place
        super.init()
    }
    
    var title: String? {
        return place.title
    }
    
}
