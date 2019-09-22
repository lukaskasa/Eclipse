//
//  ImageDownload.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 03.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

enum ImageDownloadState {
    case placeholder, downloaded, failed
}

class PendingOperations {
    
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        //queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
}

class MarsImageDownload: Operation {
    
    let roverData: MarsImage
    
    init(_ roverData: MarsImage) {
        self.roverData = roverData
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func main() {
        
        if isCancelled { return }
        
        guard let photoURL = URL(string: roverData.imgSrc), let imageData = try? Data(contentsOf: photoURL) else { return }
        
        if isCancelled { return }
        
        if !imageData.isEmpty {
            roverData.image = UIImage(data: imageData)
            roverData.state = .downloaded
        } else {
            roverData.image = UIImage(named: "nasa")
            roverData.state = .failed
        }
        
    }
    
}
