//
//  NASAClient.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 24.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

class NASAClient: APIClient {
    
    let jsonDecoder = JSONDecoder()
    var session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    /// Typealias for Earth Imagery
    typealias EarthImageryCompletionHandler = (EarthImage?, APIError?) -> Void
    
    func getEarthImageData(latitude: Double, longitude: Double, completionHandler completion: @escaping EarthImageryCompletionHandler) {
        
        // Endpoint
        let endpoint = NASA.earthImagery(latitude: latitude, longitude: longitude)
        
        performRequest(with: endpoint.request) { data, error in
            
            guard let data = data else {
                return
            }
            
            do {
                let imageInfo = try self.jsonDecoder.decode(EarthImage.self, from: data)
                completion(imageInfo, nil)
            } catch {
               completion(nil, .jsonParsingFailure)
            }
            
            if error != nil {
                print(error!.localizedDescription)
            }
            
        }
        
    }
    
    /// Typealias for Earth Image Handler Type
    typealias EarthImageCompletionHandler = (Data?, APIError?) -> Void
    
    func getImage(earthImageJSON: EarthImage, completionHandler completion: @escaping EarthImageCompletionHandler) {
        
        let url = URL(string: earthImageJSON.url)!
        let request = URLRequest(url: url)
        
        performRequest(with: request) { image, error in
        
            
            guard let image = image else {
                completion(nil, .noDataReceived)
                return
            }
            
            completion(image, nil)
        }
        
    }
    
    
    /// Typealias for Mars Imagery Rover
    typealias MarsImageryCompletionHandler = (MarsImages?, APIError?) -> Void
    
    func getMarsImages(sol: Int = 1000, camera: String? = nil, completionHandler completion: @escaping MarsImageryCompletionHandler) {
        
        let endpoint = NASA.marsRoverImagery(sol: sol, camera: camera)
        
        performRequest(with: endpoint.request) { photos, error in
            
            if let photos = photos {
                
                do {
                    
                    let images = try self.jsonDecoder.decode(MarsImages.self, from: photos)
                    completion(images, nil)
                    
                } catch {
                    
                    completion(nil, .jsonParsingFailure)
                    
                }
                
            }
            
            if error != nil {
                completion(nil, .requestFailed)
            }
            
        }
        
    }
    
    /// Typealias for Mars Weather
    typealias MarsWeatherCompletionHandler = (MarsWeatherData?, APIError?) -> Void

    
    func getMarsWeather(completionHandler completion: @escaping MarsWeatherCompletionHandler) {
        
        let endpoint = NASA.marsWeather
        
        performRequest(with: endpoint.request) { sols, error in
            
            if let sols = sols {
                
                do {
                    
                    let sols = try self.jsonDecoder.decode(MarsWeatherData.self, from: sols)
                    completion(sols, nil)
                    
                } catch {
                    
                    completion(nil, .jsonParsingFailure)
                    
                }
                
            }
            
            if error != nil {
                completion(nil, .requestFailed)
            }
            
        }
        
    }
    
    /**
     Performs the data request for the given request
     
     - Parameters:
        - request: Request used for the task to be performed with
        - completion: Completion Handler once the request is completed. (Successfully or not)
     
     - Returns: Void
     */
    func performRequest(with request: URLRequest, completion: @escaping (Data?, APIError?) -> Void) {
        
        let task = dataTask(with: request) { data, error in
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            completion(data, nil)

        }
        
        task.resume()
    }
    
}
