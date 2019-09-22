//
//  MarsImageCell.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 03.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

class MarsImageCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var marsPhotoImageView: UIImageView!
    @IBOutlet weak var marsPhotoDateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(from roverData: MarsImage) {
        marsPhotoImageView.image = roverData.image
        marsPhotoDateLabel.text = "\(roverData.id)"
    }
    
}
