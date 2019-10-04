//
//  ImageDownload.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 03.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

/// Enum representing different states of a download
enum ImageDownloadState {
    case placeholder, downloaded, failed
}

/// Pending operations class
class PendingOperations {
    
    /// Dictionary for downloads that are currently in progress
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    
    /// The download queue which takes care of the order of downloads
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        return queue
    }()
    
}

/// Download Operation for mars rover images
class MarsImageDownload: Operation {
    
    let marsRoverImage: MarsRoverImage
    
    /**
     Initializes a MarsImageDownload Operation
     
     Return: MarsImageDownload Operation
     */
    init(_ marsRoverImage: MarsRoverImage) {
        self.marsRoverImage = marsRoverImage
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    /// Main - executes the download task and asigns the downloaded image to the mars rover image object
    override func main() {
        
        if isCancelled { return }
        
        guard let photoURL = URL(string: marsRoverImage.imgSrc), let imageData = try? Data(contentsOf: photoURL) else { return }
        
        if isCancelled { return }
        
        if !imageData.isEmpty {
            marsRoverImage.image = UIImage(data: imageData)
            marsRoverImage.state = .downloaded
        } else {
            marsRoverImage.image = UIImage(named: "nasa")
            marsRoverImage.state = .failed
        }
        
    }
    
}
