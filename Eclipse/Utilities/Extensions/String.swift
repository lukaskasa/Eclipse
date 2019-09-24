//
//  String.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 19.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

extension String {
    
    func toReadableDate() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        guard let date = formatter.date(from: self) else { return nil }
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        return "\(day) \(calendar.shortMonthSymbols[month - 1])"
    }
    
}
