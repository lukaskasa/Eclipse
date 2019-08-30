//
//  APIError.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 24.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

enum APIError: Error {
    case requestFailed
    case responseUnsuccessful
    case noDataReceived
    case jsonParsingFailure
    
    var localizedDescription: String {
        switch self {
        case .requestFailed:
            return "Request failed!"
        case .responseUnsuccessful:
            return "Response was not successful."
        case .noDataReceived:
            return "No Data was received."
        case .jsonParsingFailure:
            return "JSON Parsing failed."
        }
    }
}
