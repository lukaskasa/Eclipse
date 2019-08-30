//
//  NASA.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 24.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

enum NASA {
    case earthImagery(latitude: Double, longitude: Double)
}

extension NASA: Endpoint {
    
    var base: String {
        return "https://api.nasa.gov"
    }
    
    var path: String {
        
        switch self {
        case .earthImagery:
            return "/planetary/earth/imagery/"
        }
        
    }
    
    var queryItems: [URLQueryItem] {
        
        switch self {
        case .earthImagery(latitude: let latitude, longitude: let longitude):
            return [
                URLQueryItem(name: "lon", value: longitude.description),
                URLQueryItem(name: "lat", value: latitude.description)
                //URLQueryItem(name: "dim", value: dimension.description),
                //URLQueryItem(name: "date", value: date),
                //URLQueryItem(name: "cloud_score", value: cloudScore.description)
            ]
        }
        
    }
    
    
}
