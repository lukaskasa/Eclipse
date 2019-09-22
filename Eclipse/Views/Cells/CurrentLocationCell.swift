//
//  CurrentLocationCell.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 21.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

class CurrentLocationCell: UITableViewCell {
    
    static let reuseIdentifier = "CurrentLocationCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
}
