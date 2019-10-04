//
//  MarsImage.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 03.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

/// Decodable object containing all photo object in the array for the _Mars Rover Photos_ NASA API
/// - photos: The mars rover photos array containing all mars image data
struct MarsImages: Decodable {
    let photos: [MarsRoverImage]
}

/// Decodable object representing the different type of cameras in the _Mars Rover Photos_ NASA API
/// - name: Name of the Camera
struct MarsRoverCamera: Decodable {
    let name: String
}

/// Decodable object used to represent a single Mars Rover Photo in the _Mars Rover Photos_ NASA API
/// - id: Mars Photo ID
/// - imgSrc: The Source URL for the image
/// - earthDate: When the photo was taken
/// - camera: Which camera was used to take the photo
class MarsRoverImage: Decodable {
    
    /// Properties
    let id: Int
    let imgSrc: String
    let earthDate: String
    let camera: MarsRoverCamera
    
    var image: UIImage?
    var state: ImageDownloadState = .placeholder
    
    /// Standard Initializer
    init(id: Int, imgSrc: String, earthDate: String, camera: MarsRoverCamera) {
        self.id = id
        self.imgSrc = imgSrc
        self.earthDate = earthDate
        self.camera = camera
    }
    
    /// Coding Keys
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case imgSrc = "img_src"
        case earthDate = "earth_date"
        case camera = "camera"
    }
    
    /// Required initializer to decode each property
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        imgSrc = try container.decode(String.self, forKey: .imgSrc)
        earthDate = try container.decode(String.self, forKey: .earthDate)
        camera = try container.decode(MarsRoverCamera.self, forKey: .camera)
    }
}
