//
//  MarsWeatherCell.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 17.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

/// UICollectionViewCell -  used to display the available weather information for mars
class MarsWeatherCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var solLabel: UILabel!
    @IBOutlet weak var earthDateLabel: UILabel!
    @IBOutlet weak var averageTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!

    // MARK: - Properties
    static let reuseIdentifier = "MarsWeatherCell"
    var fahrenheit = Bool()
    var sol: MarsSol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// Configure the cell all the data available from the mars sol
    func configure() {
        let unit = fahrenheit ? "℉" : "℃" 
        solLabel.text = "Sol \(sol.name)"
        earthDateLabel.text = sol.earthDate.toReadableDate()
        averageTempLabel.text = "\(sol.temperature.averageTemperature) " + unit
        minTempLabel.text = "\(sol.temperature.minTemperature) " + unit
        maxTempLabel.text = "\(sol.temperature.maxTemperature) " + unit
    }
    
}
