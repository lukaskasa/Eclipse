//
//  MarsWeather.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 16.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

/// Decodable Object representing each Mars Weather Entry from the _Insight_ NASA API
class MarsWeatherData: Decodable {
    
    /// Properties
    var sols: [MarsSol] = []
    var solKeys: [String]
    
    /// Coding Keys
    private struct WeatherDataKeys: CodingKey {
        let stringValue: String

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
        
        static let solKeys = WeatherDataKeys(stringValue: "sol_keys")!
    }
    
    /// Required Initializer to decode the json
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WeatherDataKeys.self)
        self.solKeys = try container.decode([String].self, forKey: .solKeys)
        
        self.solKeys.sort(by: >)
        
        for key in solKeys {
            let sol = try container.decode(MarsSol.self, forKey: WeatherDataKeys(stringValue: key)!)
            sol.name = key
            sols.append(sol)
        }
        
    }
    
}

/// Decodable Object representing each sol in a Mars Weather Data from the _Insight_ NASA API
class MarsSol: Decodable {
    
    /// Properties
    var name: String = ""
    var temperature: MarsTemperature
    let earthDate: String
    
    /// Coding Keys
    private struct TempCodingKeys: CodingKey {
        let stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
        
        static let temperature = TempCodingKeys(stringValue: "AT")!
        static let earthDate = TempCodingKeys(stringValue: "First_UTC")!
    }
    
    // Required Initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TempCodingKeys.self)
        self.earthDate = try container.decode(String.self, forKey: .earthDate)
        self.temperature = try container.decode(MarsTemperature.self, forKey: .temperature)
    }
    
}

/// Decodable Object representing the temperature of a Mars Weather Dataset
class MarsTemperature: Decodable {
    
    /// Properties
    var averageTemperature: Double
    var minTemperature: Double
    var maxTemperature: Double
    var averageTemperatureFahrenheit: Double
    var minTemperatureFahrenheit: Double
    var maxTemperatureFahrenheit: Double
    
    // Convert Fahrenheit to Celsius
    var averageTemperatureCelsius: Double {
        let temperature = ((averageTemperature - 32) * (5/9)) * 1000
        return Double(round(temperature) / 1000)
    }
    
    var minTemperatureCelsius: Double {
        let temperature = ((minTemperature - 32) * (5/9)) * 1000
        return Double(round(temperature) / 1000)
    }
    
    var maxTemperatureCelsius: Double {
        let temperature = ((maxTemperature - 32) * (5/9)) * 1000
        return Double(round(temperature) / 1000)
    }
    
    /// Coding Keys
    private enum CodingKeys: String, CodingKey {
        case averageTemperature = "av"
        case minTemperature = "mn"
        case maxTemperature = "mx"
    }
    
    /// Required Initializer using to decode each property
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        averageTemperature = try container.decode(Double.self, forKey: .averageTemperature)
        minTemperature = try container.decode(Double.self, forKey:  .minTemperature)
        maxTemperature = try container.decode(Double.self, forKey: .maxTemperature)
        averageTemperatureFahrenheit = averageTemperature
        minTemperatureFahrenheit = minTemperature
        maxTemperatureFahrenheit = maxTemperature
    }
    
}
