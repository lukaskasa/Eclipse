//
//  UIImageView.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 25.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
