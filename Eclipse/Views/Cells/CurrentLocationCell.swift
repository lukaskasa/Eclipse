//
//  CurrentLocationCell.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 21.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

/// UITableViewCell - Used to find the current user location when this particular cell is tapped on the tableview
class CurrentLocationCell: UITableViewCell {
    
    /// Cell reuseidentifier
    static let reuseIdentifier = "CurrentLocationCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
}
