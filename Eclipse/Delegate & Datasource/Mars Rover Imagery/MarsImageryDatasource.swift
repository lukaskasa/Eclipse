//
//  MarsImageryDatasource.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 03.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

class MarsImageryDatasource: NSObject, UICollectionViewDataSource {
    
    /// Properties
    let pendingOperations = PendingOperations()
    let collectionView: UICollectionView
    var images: [MarsRoverImage]
    
    /**
     Initializes a UICollectionViewDataource Object for the Mars Imagery
     
     - Parameters:
        - images: Array of MarsRoverImage objects
        - collectionView: UICollectionView used to display the data
     
     - Returns:  A UICollectionViewDataource Object
     */
    init(images: [MarsRoverImage], collectionView: UICollectionView) {
        self.images = images
        self.collectionView = collectionView
    }
    
    /// Asks your data source object for the number of items in the specified section.
    /// Apple documentation: https://developer.apple.com/documentation/uikit/uicollectionviewdatasource/1618058-collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    /// Asks your data source object for the cell that corresponds to the specified item in the collection view.
    /// Apple documentation: https://developer.apple.com/documentation/uikit/uicollectionviewdatasource/1618029-collectionview
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MarsImageCell.self), for: indexPath) as! MarsImageCell
       
        let image = images[indexPath.row]
        
        cell.configure(from: image)
        
        if image.state == .placeholder {
            cell.activityIndicator.startAnimating()
            downloadMarsImage(for: image, at: indexPath)
        } else if image.state == .downloaded {
            cell.activityIndicator.stopAnimating()
        }

        return cell
        
    }
    
    
    // MARK: - Helper
    
    /**
     Feed the images array with new data
     
     - Parameters:
        - images: MarsRoverImage Array
     
     - Returns: Void
     */
    func update(with images: [MarsRoverImage]) {
        self.images = images
    }
    
    /**
     Starts the download operation for each MarsRoverImage object at a particular IndexPath
     
     - Parameters:
        - roverData: The Mars Rover Image used to download the particular image
        - indexPath: IndexPath of particular collectionview cell
     
     - Returns: Void
     */
    func downloadMarsImage(for roverData: MarsRoverImage, at indexPath: IndexPath) {
        
        guard pendingOperations.downloadsInProgress[indexPath] == nil else { return }
        
        let downloader = MarsImageDownload(roverData)
        
        downloader.completionBlock = {
            
            if downloader.isCancelled { return }
            
            DispatchQueue.main.async {
                
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.collectionView.reloadItems(at: [indexPath])
                
            }
            
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        
        pendingOperations.downloadQueue.addOperation(downloader)
        
    }
    
}
