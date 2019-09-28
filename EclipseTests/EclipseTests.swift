//
//  EclipseTests.swift
//  EclipseTests
//
//  Created by Lukas Kasakaitis on 24.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation
import XCTest
@testable import Eclipse

class EclipseTests: XCTestCase {

    // MARK: - Properties
    var earthImageJSON: Data!
    
    var marsRoverJSON: Data!
    
    var marsWeatherJSON: Data!
    
    var client: NASAClient!
    
    override func setUp() {
        super.setUp()
        
        earthImageJSON = """
        {
          "cloud_score": 0.03926652301686606,
          "date": "2014-02-04T03:30:01",
          "id": "LC8_L1T_TOA/LC81270592014035LGN00",
          "resource": {
            "dataset": "LC8_L1T_TOA",
            "planet": "earth"
          },
          "service_version": "v1",
          "url": "https://earthengine.googleapis.com/api/thumb?thumbid=bc77b079c8ecd07cd668c576c22b83a4&token=36613186659d22a4a59bcea403ff2efc"
        }
        """.data(using: .utf8)!
        
        marsRoverJSON = """
        {
            "photos": [
                {
                    "id": 687036,
                    "sol": 2490,
                    "camera": {
                        "id": 21,
                        "name": "RHAZ",
                        "rover_id": 5,
                        "full_name": "Rear Hazard Avoidance Camera"
                    },
                    "img_src": "https://mars.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/02490/opgs/edr/rcam/RLB_618550748EDR_F0763002RHAZ00337M_.JPG",
                    "earth_date": "2019-08-08",
                    "rover": {
                        "id": 5,
                        "name": "Curiosity",
                        "landing_date": "2012-08-06",
                        "launch_date": "2011-11-26",
                        "status": "active",
                        "max_sol": 2537,
                        "max_date": "2019-09-25",
                        "total_photos": 366023,
                        "cameras": [
                            {
                                "name": "FHAZ",
                                "full_name": "Front Hazard Avoidance Camera"
                            },
                            {
                                "name": "NAVCAM",
                                "full_name": "Navigation Camera"
                            },
                            {
                                "name": "MAST",
                                "full_name": "Mast Camera"
                            },
                            {
                                "name": "CHEMCAM",
                                "full_name": "Chemistry and Camera Complex"
                            },
                            {
                                "name": "MAHLI",
                                "full_name": "Mars Hand Lens Imager"
                            },
                            {
                                "name": "MARDI",
                                "full_name": "Mars Descent Imager"
                            },
                            {
                                "name": "RHAZ",
                                "full_name": "Rear Hazard Avoidance Camera"
                            }
                        ]
                    }
                }
            ]
        }
        """.data(using: .utf8)!
        
        marsWeatherJSON = """
        {
            "289": {
              "AT": {
                "av": -73.447,
                "ct": 104016,
                "mn": -102.842,
                "mx": -27.301
              },
              "First_UTC": "2019-09-19T03:51:37Z",
              "HWS": {
                "av": 4.248,
                "ct": 49481,
                "mn": 0.13,
                "mx": 17.367
              },
              "Last_UTC": "2019-09-20T04:31:11Z",
              "PRE": {
                "av": 742.051,
                "ct": 103812,
                "mn": 721.2357,
                "mx": 757.1103
              },
              "Season": "spring",
              "WD": {
                "1": {
                  "compass_degrees": 22.5,
                  "compass_point": "NNE",
                  "compass_right": 0.382683432365,
                  "compass_up": 0.923879532511,
                  "ct": 1
                },
                "10": {
                  "compass_degrees": 225.0,
                  "compass_point": "SW",
                  "compass_right": -0.707106781187,
                  "compass_up": -0.707106781187,
                  "ct": 11894
                },
                "11": {
                  "compass_degrees": 247.5,
                  "compass_point": "WSW",
                  "compass_right": -0.923879532511,
                  "compass_up": -0.382683432365,
                  "ct": 2930
                },
                "12": {
                  "compass_degrees": 270.0,
                  "compass_point": "W",
                  "compass_right": -1.0,
                  "compass_up": -0.0,
                  "ct": 728
                },
                "2": {
                  "compass_degrees": 45.0,
                  "compass_point": "NE",
                  "compass_right": 0.707106781187,
                  "compass_up": 0.707106781187,
                  "ct": 13
                },
                "3": {
                  "compass_degrees": 67.5,
                  "compass_point": "ENE",
                  "compass_right": 0.923879532511,
                  "compass_up": 0.382683432365,
                  "ct": 129
                },
                "5": {
                  "compass_degrees": 112.5,
                  "compass_point": "ESE",
                  "compass_right": 0.923879532511,
                  "compass_up": -0.382683432365,
                  "ct": 691
                },
                "6": {
                  "compass_degrees": 135.0,
                  "compass_point": "SE",
                  "compass_right": 0.707106781187,
                  "compass_up": -0.707106781187,
                  "ct": 9885
                },
                "7": {
                  "compass_degrees": 157.5,
                  "compass_point": "SSE",
                  "compass_right": 0.382683432365,
                  "compass_up": -0.923879532511,
                  "ct": 8659
                },
                "8": {
                  "compass_degrees": 180.0,
                  "compass_point": "S",
                  "compass_right": 0.0,
                  "compass_up": -1.0,
                  "ct": 7397
                },
                "9": {
                  "compass_degrees": 202.5,
                  "compass_point": "SSW",
                  "compass_right": -0.382683432365,
                  "compass_up": -0.923879532511,
                  "ct": 7154
                },
                "most_common": {
                  "compass_degrees": 225.0,
                  "compass_point": "SW",
                  "compass_right": -0.707106781187,
                  "compass_up": -0.707106781187,
                  "ct": 11894
                }
              }
            },
            "sol_keys": [
              "289"
            ],
        }
        """.data(using: .utf8)!
        
        client = NASAClient()
    
    }
    
    override func tearDown() {
        super.tearDown()
        earthImageJSON = nil
        marsRoverJSON = nil
        marsWeatherJSON = nil
        client = nil
    }
    
    
    // MARK: - Tests - General
    
    func testAPIConnection() {
        let url = URL(string: "https://api.nasa.gov")!
        let request = URLRequest(url: url)
        
        let expectation = XCTestExpectation(description: "API Connection")
        
        client.performRequest(with: request) { data, _ in
            if data != nil {
                XCTAssert(true)
                expectation.fulfill()
            } else {
                XCTAssert(false)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    // MARK: - Tests - Eye in the Sky
    
    func testEarthImageJSONParsing() {
        XCTAssertNoThrow(try JSONDecoder().decode(EarthImage.self, from: earthImageJSON), "JSON could not be parsed!")
    }
    
    func testEarthImageAPI() {

        let expectation = XCTestExpectation(description: "Earth Imagery API")
        let latitude = 45.0
        let longitude = 45.0
        
        client.getEarthImageData(latitude: latitude, longitude: longitude) { imageData,error in
            
            if let _ = imageData {
                XCTAssert(true)
                expectation.fulfill()
            }
            
            if error != nil {
                XCTAssert(false)
                expectation.fulfill()
            }

        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    // MARK: - Tests - Mars Rover Postcard Maker
    
    func testMarsRoverPostcardJSONParsing() {
        XCTAssertNoThrow(try JSONDecoder().decode(MarsImages.self, from: marsRoverJSON), "JSON could not be parsed!")
    }
    
    func testMarsRoverImageryAPI() {
        
        let expectation = XCTestExpectation(description: "Mars Rover Imagery API")
        
        client.getMarsImages { marsImageData,error in
            
            if let _ = marsImageData {
                XCTAssert(true)
                expectation.fulfill()
            }
            
            if error != nil {
                XCTAssert(false)
                expectation.fulfill()
            }
            
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    // MARK: - Tests - Mars Weather
    
    func testMarsWeatherJSONParsing() {
        XCTAssertNoThrow(try JSONDecoder().decode(MarsWeatherData.self, from: marsWeatherJSON), "JSON could not be parsed")
    }
    
    func testMarsWeatherAverageTemperatureConversion() {
        
        guard let sol = try! JSONDecoder().decode(MarsWeatherData.self, from: marsWeatherJSON).sols.first else { return }
        let fahreheit = sol.temperature.averageTemperatureFahrenheit
        let celsius = Double(round(((fahreheit - 32) * (5/9)) * 1000) / 1000)
        
        XCTAssertEqual(sol.temperature.averageTemperatureCelsius, celsius)
    }
    
    func testMarsWeatherMinimumTemperatureConversion() {
        
        guard let sol = try! JSONDecoder().decode(MarsWeatherData.self, from: marsWeatherJSON).sols.first else { return }
        let fahreheit = sol.temperature.minTemperatureFahrenheit
        let celsius = Double(round(((fahreheit - 32) * (5/9)) * 1000) / 1000)
        
        XCTAssertEqual(sol.temperature.minTemperatureCelsius, celsius)
    }
    
    func testMarsWeatherMaximumTemperatureConversion() {
        
        guard let sol = try! JSONDecoder().decode(MarsWeatherData.self, from: marsWeatherJSON).sols.first else { return }
        let fahreheit = sol.temperature.maxTemperatureFahrenheit
        let celsius = Double(round(((fahreheit - 32) * (5/9)) * 1000) / 1000)
        
        XCTAssertEqual(sol.temperature.maxTemperatureCelsius, celsius)
    }
    
    func testMarsWeatherAPI() {
        
        let expectation = XCTestExpectation(description: "Mars Weather API")
        
        client.getMarsWeather { weatherData,error in
            
            if let _ = weatherData {
                XCTAssert(true)
                expectation.fulfill()
            }
            
            if error != nil {
                XCTAssert(false)
                expectation.fulfill()
            }
            
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
}
