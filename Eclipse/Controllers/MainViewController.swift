//
//  MainViewController.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 12.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

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
        // Do any additional setup after loading the view.
        addGestureRecognizers()
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
    
    func addGestureRecognizers() {
        
        let earthImageryGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navigateToEyeInTheSky))
        eyeInTheSkyView.isUserInteractionEnabled = true
        eyeInTheSkyView.addGestureRecognizer(earthImageryGestureRecognizer)
        
        let marsImageryGestureRecogizer = UITapGestureRecognizer(target: self, action: #selector(navigateToRoverPostcardMaker))
        roverPostcardMakerView.isUserInteractionEnabled = true
        roverPostcardMakerView.addGestureRecognizer(marsImageryGestureRecogizer)
        
        let marsWeatherGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navigateToMarsWeather))
        marsWeatherView.isUserInteractionEnabled = true
        marsWeatherView.addGestureRecognizer(marsWeatherGestureRecognizer)
    }
    
    @objc func navigateToEyeInTheSky() {
        
        let earthViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: EarthViewController.self)) as! EarthViewController
        
        earthViewController.modalPresentationStyle = .formSheet
        earthViewController.modalTransitionStyle = .coverVertical

        present(earthViewController, animated: true, completion: nil)
    }
    
    @objc func navigateToRoverPostcardMaker() {
        
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
    
    @objc func navigateToMarsWeather() {
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

