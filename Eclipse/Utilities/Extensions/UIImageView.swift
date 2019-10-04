//
//  UIImageView.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 14.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// Get the real image rect to perform the correct crop on the image
    func getRealImageRect() -> CGRect {
        
        let imageViewSize = self.frame.size
        let imgSize = self.image?.size
        
        guard let imageSize = imgSize else { return CGRect.zero }
        
        let scaleWidth = imageViewSize.width / imageSize.width
        let scaleHeight = imageViewSize.height / imageSize.height
        let aspect = fmin(scaleWidth, scaleHeight)
        
        var imageRect = CGRect(x: 0, y: 0, width: imageSize.width * aspect, height: imageSize.height * aspect)
        
        imageRect.origin.x = (imageViewSize.width - imageRect.size.width) / 2.0
        imageRect.origin.y = (imageViewSize.height - imageRect.size.height) / 2.0
        
        imageRect.origin.x += self.frame.origin.x
        imageRect.origin.y += self.frame.origin.y
        
        return imageRect
    }
    
}
