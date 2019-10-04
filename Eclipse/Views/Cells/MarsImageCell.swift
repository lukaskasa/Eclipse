//
//  MarsImageCell.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 03.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

/// UICollectionViewCell - used to load in the mars rover image with th camera name underneath the image
class MarsImageCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var marsPhotoImageView: UIImageView!
    @IBOutlet weak var marsPhotoDateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// Configure the cell with the image and camera name
    func configure(from roverData: MarsRoverImage) {
        marsPhotoImageView.image = roverData.image
        marsPhotoDateLabel.text = roverData.camera.name
    }
    
}
