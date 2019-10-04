//
//  EarthImage.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 23.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

/// Decodable object used for the _Earth_  NASA API
/// - date: The date the satelite image was taken
/// - url: The URL of the particular image
struct EarthImage: Decodable {
    let date: String
    let url: String
}
