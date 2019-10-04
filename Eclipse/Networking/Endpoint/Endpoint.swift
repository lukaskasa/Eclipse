//
//  Endpoint.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 24.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

/// Protocol consisting of all the components for each endpoint
protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    
    /// Parameter for the API Key
    var apiKey: URLQueryItem {
        return URLQueryItem(name: "api_key", value: Secrets.apiKey)
    }
    
    /// Parse the URL using the URLComponents struct
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryItems
        components.queryItems?.append(apiKey)
        return components
    }
    
    /// URL Request representation
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
    
}

