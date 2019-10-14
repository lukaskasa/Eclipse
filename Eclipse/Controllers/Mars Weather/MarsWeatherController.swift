//
//  MarsWeatherController.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 16.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit
import SceneKit

/// Mars Weather Controller to manage the display of mars weather data
class MarsWeatherController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var marsSceneView: UIView!
    
    // MARK: - Properties
    let client = NASAClient()
    let marsView = MarsSceneView()
    var navigationBar: NavigationBar?
    
    var solWeather: [MarsSol]? {
        didSet {
            datasource.update(with: solWeather!)
            collectionView.reloadData()
        }
    }
    
    lazy var delegate: MarsWeatherDelegate = {
        return MarsWeatherDelegate()
    }()
    
    lazy var datasource: MarsWeatherDatasource = {
        return MarsWeatherDatasource(solWeather: [], collectionView: self.collectionView)
    }()
    
    /// Hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup
        setupNavigationBar()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupMarsSceneView()
    }
    
    // MARK: - Helper
    
    /// Setup the navigation bar
    func setupNavigationBar() {
        navigationBar = NavigationBar(for: self.view, navigationBarStyle: .black, tintColor: .white, title: "Mars Weather", leftButton: .back, rightButton: .celsius, leftButtonAction: #selector(mainView), rightButtonAction: #selector(celsius))
        navigationBar?.load()
    }
    
    @objc func mainView() {
        dismiss(animated: true, completion: nil)
    }
    
    /// @objc method to set the degree units to Celsius
    @objc func celsius() {
        datasource.toCelsius()
        navigationBar?.rightButtonAction = #selector(fahrenheit)
        navigationBar?.rightButton = .fahrenheit
        navigationBar?.load()
    }
    
    /// @objc method to set the degree units to Fahrenheit
    @objc func fahrenheit() {
        datasource.toFahrenheit()
        navigationBar?.rightButtonAction = #selector(celsius)
        navigationBar?.rightButton = .celsius
        navigationBar?.load()
    }
    
    /// Setup the Collectionview with the delegate and datasource
    func setupCollectionView() {
        collectionView.delegate = delegate
        collectionView.dataSource = datasource
        collectionView.reloadData()
    }
    
    func setupMarsSceneView() {
        marsSceneView.addSubview(marsView)
        marsView.translatesAutoresizingMaskIntoConstraints = false
        marsView.topAnchor.constraint(equalTo: marsSceneView.topAnchor, constant: 0.0).isActive = true
        marsView.rightAnchor.constraint(equalTo: marsSceneView.rightAnchor, constant: 0.0).isActive = true
        marsView.bottomAnchor.constraint(equalTo: marsSceneView.bottomAnchor, constant: 0.0).isActive = true
        marsView.leftAnchor.constraint(equalTo: marsSceneView.leftAnchor, constant: 0.0).isActive = true
    }
    
}
