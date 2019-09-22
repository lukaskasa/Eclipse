//
//  MarsImage.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 03.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

struct MarsImages: Decodable {
    let photos: [MarsImage]
}

class MarsImage: Decodable {
    
    let id: Int
    let imgSrc: String
    let earthDate: String
    
    var image: UIImage?
    var state: ImageDownloadState = .placeholder
    
    init(id: Int, imgSrc: String, earthDate: String) {
        self.id = id
        self.imgSrc = imgSrc
        self.earthDate = earthDate
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case imgSrc = "img_src"
        case earthDate = "earth_date"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        imgSrc = try container.decode(String.self, forKey: .imgSrc)
        earthDate = try container.decode(String.self, forKey: .earthDate)
    }
}
