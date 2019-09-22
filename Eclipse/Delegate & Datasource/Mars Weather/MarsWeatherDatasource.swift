//
//  MarsWeatherDatasource.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 17.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

class MarsWeatherDatasource: NSObject, UICollectionViewDataSource {
    
    private var fahrenheit = true
    private var solWeather: [MarsSol]
    private let collectionView: UICollectionView
    
    init(solWeather: [MarsSol], collectionView: UICollectionView) {
        self.solWeather = solWeather
        self.collectionView = collectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return solWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarsWeatherCell.reuseIdentifier, for: indexPath) as! MarsWeatherCell
        
        let sol = solWeather[indexPath.row]
        cell.fahrenheit = fahrenheit
        cell.sol = sol
        cell.configure()
        
        return cell
    }
    
    // MARK: - Helper
    
    func update(with sols: [MarsSol]) {
        self.solWeather = sols
    }
    
    func toCelsius(){
        fahrenheit = false
        for sol in solWeather {
            sol.temperature.averageTemperature = sol.temperature.averageTemperatureCelsius
            sol.temperature.minTemperature = sol.temperature.minTemperatureCelsius
            sol.temperature.maxTemperature = sol.temperature.maxTemperatureCelsius
        }
        collectionView.reloadData()
    }
    
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
