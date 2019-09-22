//
//  MarsWeather.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 16.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

class MarsWeatherData: Decodable {
    
    var sols: [MarsSol] = []
    var solKeys: [String]
    
    private struct WeatherDataKeys: CodingKey {
        let stringValue: String

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
        
        static let solKeys = WeatherDataKeys(stringValue: "sol_keys")!
    }
    
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

class MarsSol: Decodable {
    var name: String = ""
    var temperature: MarsTemperature
    let earthDate: String
    
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
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TempCodingKeys.self)
        self.earthDate = try container.decode(String.self, forKey: .earthDate)
        self.temperature = try container.decode(MarsTemperature.self, forKey: .temperature)
    }
    
}

class MarsTemperature: Decodable {
    
    var averageTemperature: Double
    var minTemperature: Double
    var maxTemperature: Double
    
    var averageTemperatureCelsius: Double {
        let temperature = ((averageTemperature - 32) * (5/9)) * 1000
        return Double(round(temperature) / 1000)
    }
    
    var minTemperatureCelsius: Double {
        let temperature = ((minTemperature - 32) * (5/9)) * 1000
        return Double(round(temperature / 1000))
    }
    
    var maxTemperatureCelsius: Double {
        let temperature = ((maxTemperature - 32) * (5/9)) * 1000
        return Double(round(temperature) / 1000)
    }
    
    var averageTemperatureFahrenheit: Double {
        let temperature = ((averageTemperature * (9/5)) + 32) * 1000
        return Double(round(temperature) / 1000)
    }
    
    var minTemperatureFahrenheit: Double {
        let temperature = ((minTemperature * (9/5)) + 32) * 1000
        return Double(round(temperature) / 1000)
    }
    
    var maxTemperatureFahrenheit: Double {
        let temperature = ((maxTemperature * (9/5)) + 32) * 1000
        return Double(round(temperature) / 1000)
    }
    
    private enum CodingKeys: String, CodingKey {
        case averageTemperature = "av"
        case minTemperature = "mn"
        case maxTemperature = "mx"
    }
    
    init(averageTemperature: Double, minTemperature: Double, maxTemperature: Double) {
        self.averageTemperature = averageTemperature
        self.minTemperature = minTemperature
        self.maxTemperature = maxTemperature
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        averageTemperature = try container.decode(Double.self, forKey: .averageTemperature)
        minTemperature = try container.decode(Double.self, forKey:  .minTemperature)
        maxTemperature = try container.decode(Double.self, forKey: .maxTemperature)
    }
    
}
