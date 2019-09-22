//
//  MarsImageryDatasource.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 03.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

class MarsImageryDatasource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Properties
    
    let pendingOperations = PendingOperations()
    let collectionView: UICollectionView
    var images: [MarsImage]
    
    init(images: [MarsImage], collectionView: UICollectionView) {
        self.images = images
        self.collectionView = collectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
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
    
    func update(with images: [MarsImage]) {
        self.images = images
    }
    
    func downloadMarsImage(for roverData: MarsImage, at indexPath: IndexPath) {
        
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
