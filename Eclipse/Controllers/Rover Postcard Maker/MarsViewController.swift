//
//  MarsViewController.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 03.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

class MarsViewController: UICollectionViewController {
    
    // MARK: - Properties
    let client = NASAClient()
    var navigationBar: NavigationBar?
    var navItem = UINavigationItem(title: "Rover Postcard Maker")
    
    lazy var marsFilter = MarsImageryFilter(view: self.view)
    
    lazy var datasource: MarsImageryDatasource = {
        return MarsImageryDatasource(images: [], collectionView: self.collectionView)
    }()
    
    var loadAnimation: LoadAnimation!
    
    var images: [MarsRoverImage]? {
        didSet {
            datasource.update(with: images!)
            collectionView.reloadData()
            navigationBar?.rightButton = .controls
            navigationBar?.load()
            loadAnimation?.stop()
            view.viewWithTag(20)?.isHidden = true
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup
        setupAnimation()
        loadAnimation?.start()
        setupNavigationBar()
        setupCollectionView()
        marsFilter.setup()
        setFilterAction()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showImage" {
            
            if let cell = sender as? MarsImageCell, let indexPath = collectionView.indexPath(for: cell), let pageViewController = segue.destination as? ImagePageViewController {
                pageViewController.imageIndexPath = indexPath
                pageViewController.images = datasource.images
                pageViewController.indexOfCurrentImage = indexPath.row
            }
            
        }
        
    }
    
    // MARK: - Helper Methods
    
    
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = datasource
    }
    
    func setupAnimation() {
        // TODO: Put into LoadAnimation object
        let dimView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        dimView.tag = 20
        view.addSubview(dimView)
        loadAnimation = LoadAnimation(for: self.view)
        view.addSubview(loadAnimation)
        loadAnimation.translatesAutoresizingMaskIntoConstraints = false
        loadAnimation.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadAnimation.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    func setupNavigationBar() {
        navigationBar = NavigationBar(for: self.view, navigationBarStyle: .black, tintColor: .white, title: "Rover Postcard Maker", leftButton: .back, rightButton: nil, leftButtonAction: #selector(exit), rightButtonAction: #selector(showPicker))
        navigationBar?.load()
    }
    
    @objc func exit() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func showPicker() {
        marsFilter.open()
    }
    
    func setFilterAction() {
        
        marsFilter.filterAction = {
            
            let selectedSol = self.marsFilter.sols[self.marsFilter.pickerView.selectedRow(inComponent: 0)]
            let selectedCamera = self.marsFilter.cameras[self.marsFilter.pickerView.selectedRow(inComponent: 1)]
            
            self.loadAnimation?.start()
            self.view.viewWithTag(20)?.isHidden = false
            self.navigationBar?.rightButton = nil
            
            self.client.getMarsImages(sol: selectedSol, camera: selectedCamera) { images, error in
                
                if let marsImageData = images {
                    
                    DispatchQueue.main.async {
                        self.images = marsImageData.photos
                        self.collectionView.reloadData()
                    }
                    
                }
                
                if error != nil {
                    print(error!.localizedDescription)
                }
                
            }
            
        }
        
    }
    
}
