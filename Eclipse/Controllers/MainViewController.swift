//
//  MainViewController.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 12.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit
import SystemConfiguration

class MainViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var startStackView: UIStackView!
    @IBOutlet weak var eyeInTheSkyView: UIView!
    @IBOutlet weak var roverPostcardMakerView: UIView!
    @IBOutlet weak var marsWeatherView: UIView!
    @IBOutlet weak var marsTemperatureLabel: UILabel! {
        didSet {
            getLatestMarsTemperature()
        }
    }
    
    // MARK: - Properties
    let client = NASAClient()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup
        addGestureRecognizers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkForInternetConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Helper
    
    /// Check if internet connection is available
    func checkForInternetConnection() {
        if Reachability.sharedInstance.isConnectedToNetwork() {
            startStackView.isUserInteractionEnabled = true
        } else {
            startStackView.isUserInteractionEnabled = false
            showSettingsAlert(with: "No internet connection", and: "To use this applcation you requrie a working internet connection.")
        }
    }
    
    /// Gets and displays the latest temperature information avalable from the NASA Insight API
    func getLatestMarsTemperature() {
        
        client.getMarsWeather { weatherData, error in
            
            guard let weatherData = weatherData, let temperature = weatherData.sols.last?.temperature else { return }
            let fahrenheit = temperature.averageTemperature
            let celsius = temperature.averageTemperatureCelsius
            
            DispatchQueue.main.async {
                self.marsTemperatureLabel.text = "\(fahrenheit) ℉ | \(celsius) ℃"
            }
            
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    /// Adds gesture recgonizer to all three modules
    func addGestureRecognizers() {
        
        let earthImageryGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showEyeInTheSky))
        eyeInTheSkyView.isUserInteractionEnabled = true
        eyeInTheSkyView.addGestureRecognizer(earthImageryGestureRecognizer)
        
        let marsImageryGestureRecogizer = UITapGestureRecognizer(target: self, action: #selector(showRoverPostcardMaker))
        roverPostcardMakerView.isUserInteractionEnabled = true
        roverPostcardMakerView.addGestureRecognizer(marsImageryGestureRecogizer)
        
        let marsWeatherGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMarsWeather))
        marsWeatherView.isUserInteractionEnabled = true
        marsWeatherView.addGestureRecognizer(marsWeatherGestureRecognizer)
    }
    
    /// Shows the the Eye in the Sky module using a modal transition Style
    @objc func showEyeInTheSky() {
        
        let earthViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: EarthViewController.self)) as! EarthViewController
        
        earthViewController.modalPresentationStyle = .formSheet
        earthViewController.modalTransitionStyle = .coverVertical

        present(earthViewController, animated: true, completion: nil)
    }
    
    /// Shows the the Rover Postcard module using a modal transition Style
    @objc func showRoverPostcardMaker() {
        
        let marsViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: MarsViewController.self)) as! MarsViewController
        
        marsViewController.modalPresentationStyle = .formSheet
        marsViewController.modalTransitionStyle = .coverVertical
        
        client.getMarsImages() { images, error in
            
            if let marsImageData = images {
               
                DispatchQueue.main.async {
                    marsViewController.images = marsImageData.photos
                    marsViewController.collectionView.reloadData()
                }
                
            }
            
            if error != nil {
                print(error!.localizedDescription)
            }
            
        }
        
        present(marsViewController, animated: true, completion: nil)
    }
    
    /// Shows the the Mars Weather module using a modal transition Style
    @objc func showMarsWeather() {
        let marsWeatherController = storyboard?.instantiateViewController(withIdentifier: String(describing: MarsWeatherController.self)) as! MarsWeatherController
        
        client.getMarsWeather { data, error in
            
            DispatchQueue.main.async {
                if let weatherData = data {
                    marsWeatherController.solWeather = weatherData.sols
                }
                
                if error != nil {
                    print(error!.localizedDescription)
                }
                
            }

        }
        
        marsWeatherController.modalPresentationStyle = .formSheet
        marsWeatherController.modalTransitionStyle = .coverVertical
        
        present(marsWeatherController, animated: true, completion: nil)
    }

}

