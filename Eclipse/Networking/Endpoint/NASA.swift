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
    case marsRoverImagery(sol: Int, camera: String?)
    case marsWeather
}

extension NASA: Endpoint {
    
    var base: String {
        return "https://api.nasa.gov"
    }
    
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
        case .marsRoverImagery(sol: let sol, camera: let camera):
            return [
                URLQueryItem(name: "sol", value: sol.description),
                URLQueryItem(name: "camera", value: camera)
                //URLQueryItem(name: "page", value: page)
            ]
        case .marsWeather:
            return [
                URLQueryItem(name: "ver", value: "1.0"),
                URLQueryItem(name: "feedtype", value: "json")
            ]
        }
        
    }
    
    
}
