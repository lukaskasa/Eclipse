//
//  MarsWeatherDatasource.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 17.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

/// UICollectionViewDataSource Object
class MarsWeatherDatasource: NSObject, UICollectionViewDataSource {
    
    /// Properties
    private var fahrenheit = true
    private var solWeather: [MarsSol]
    private let collectionView: UICollectionView
    
    /**
     Initializes a UICollectionViewDataource Object
     
     - Parameters:
        - solWeather: Array of MarsSol containing weather data in particular the temperature
        - collectionView: UICollectionView used to display the data
     
     - Returns:  A UICollectionViewDataource Object
     */
    init(solWeather: [MarsSol], collectionView: UICollectionView) {
        self.solWeather = solWeather
        self.collectionView = collectionView
    }
    /// Asks your data source object for the number of items in the specified section.
    /// Apple documentation:
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return solWeather.count
    }
    
    /// Asks your data source object for the cell that corresponds to the specified item in the collection view.
    /// Apple documentation:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarsWeatherCell.reuseIdentifier, for: indexPath) as! MarsWeatherCell
        
        let sol = solWeather[indexPath.row]
        cell.fahrenheit = fahrenheit
        cell.sol = sol
        cell.configure()
        
        return cell
    }
    
    // MARK: - Helper
    
    /**
     Feed the sols array with new data
     
     - Parameters:
        - sols: MarsSol Array
     
     - Returns: Void
     */
    func update(with sols: [MarsSol]) {
        self.solWeather = sols
    }
    
    /// Switch units to Celsius
    func toCelsius(){
        fahrenheit = false
        for sol in solWeather {
            sol.temperature.averageTemperature = sol.temperature.averageTemperatureCelsius
            sol.temperature.minTemperature = sol.temperature.minTemperatureCelsius
            sol.temperature.maxTemperature = sol.temperature.maxTemperatureCelsius
        }
        collectionView.reloadData()
    }
    
    /// Switch units to Fahrenheit
    func toFahrenheit() {
        fahrenheit = true
        for sol in solWeather {
            sol.temperature.averageTemperature = sol.temperature.averageTemperatureFahrenheit
            sol.temperature.minTemperature = sol.temperature.minTemperatureFahrenheit
            sol.temperature.maxTemperature = sol.temperature.maxTemperatureFahrenheit
        }
        collectionView.reloadData()
    }
    
}
