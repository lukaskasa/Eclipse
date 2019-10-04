//
//  NASA.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 24.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

/// Enum representing the different NASA API Endpoints -> https://api.nasa.gov
enum NASA {
    /// "Earth: Unlock the significant public investment in earth observation Data"
    case earthImagery(latitude: Double, longitude: Double)
    /// ''Mars Rover Photos: Image data gathered by NASA's Curiosity, Opportunity and Spirit Rovers on Mars "
    case marsRoverImagery(sol: Int, camera: String?)
    /// "Insight: Mars Weather Service API"
    case marsWeather
}

extension NASA: Endpoint {
    
    /// Base URL
    var base: String {
        return "https://api.nasa.gov"
    }
    
    /// Endpoint directories
    var path: String {
        
        switch self {
        case .earthImagery:
            return "/planetary/earth/imagery/"
        case .marsRoverImagery:
            return "/mars-photos/api/v1/rovers/curiosity/photos/"
        case .marsWeather:
            return "/insight_weather/"
        }
        
    }
    
    /// Endpoint parameters
    var queryItems: [URLQueryItem] {
        
        switch self {
        case .earthImagery(latitude: let latitude, longitude: let longitude):
            return [
                URLQueryItem(name: "lon", value: longitude.description),
                URLQueryItem(name: "lat", value: latitude.description)
            ]
        case .marsRoverImagery(sol: let sol, camera: let camera):
            return [
                URLQueryItem(name: "sol", value: sol.description),
                URLQueryItem(name: "camera", value: camera)
            ]
        case .marsWeather:
            return [
                URLQueryItem(name: "ver", value: "1.0"),
                URLQueryItem(name: "feedtype", value: "json")
            ]
        }
        
    }
    
}
