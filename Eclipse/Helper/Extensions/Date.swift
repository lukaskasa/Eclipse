//
//  Date.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 24.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

extension Date {
    
    func yearFirst() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-d"
        let date = formatter.string(from: self)
        
        return date
    }
    
}
