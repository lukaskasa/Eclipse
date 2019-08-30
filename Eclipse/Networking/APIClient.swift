//
//  APIClient.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 23.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

/// APIClient protocol
protocol APIClient {
    var session: URLSession { get }
    var jsonDecoder: JSONDecoder { get }
}

/// Default implentation for the APIClient protocol
extension APIClient {
    
    /// Typealias for the completionHandler
    typealias DataTaskCompletionHandler = (Data?, APIError?) -> Void
    
    /**
     Data task
     
     - Parameters:
        - request: The request passed in
        - completion: Completion Handler to be executed after the task is completed.
     
     - Returns: A session task to retrieve data using the given request
     */
    func dataTask(with request: URLRequest, completionHandler completion: @escaping DataTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { data, response, error in
            
            // 1 - Check if a response is received else return and complete with an error
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            // 2 - Check if the response is successful then complete with the data else return and complete with an error
            if httpResponse.statusCode == 200 {
                
                if let data = data {
                    completion(data, nil)
                }
                
            } else {
                print("Unsuccessful :( - Status Code: \(httpResponse.statusCode)")
                completion(nil, .responseUnsuccessful)
            }
            
        }
        
        return task
    }
    
}
