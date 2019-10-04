//
//  MarsWeatherDelegate.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 17.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

class MarsWeatherDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /// The cellwidth used
    private let cellWidth: CGFloat = 200.0
    
    /// Asks the delegate for the margins to apply to content in the specified section.
    /// Apple Documentation: https://developer.apple.com/documentation/appkit/nscollectionviewdelegateflowlayout/1402874-collectionview
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let inset = (collectionView.frame.width - cellWidth) / 2.0
        
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
}
