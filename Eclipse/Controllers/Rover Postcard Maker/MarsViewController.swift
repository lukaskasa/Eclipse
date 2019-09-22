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
    var delegate: MarsImageryDelegate?
    var navigationBar: NavigationBar?
    var navItem = UINavigationItem(title: "Rover Postcard Maker")
    
    lazy var marsFilter = MarsImageryFilter(view: self.view)
    
    lazy var datasource: MarsImageryDatasource = {
        return MarsImageryDatasource(images: [], collectionView: self.collectionView)
    }()
    
    lazy var loadAnimation: LoadAnimation? = {
        return LoadAnimation(for: self.view)
    }()
    
    var images: [MarsImage]? {
        didSet {
            delegate = MarsImageryDelegate()
            datasource.update(with: images!)
            collectionView.reloadData()
            loadAnimation?.stop()
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
        addAction()
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
        self.collectionView.delegate = delegate
        self.collectionView.dataSource = datasource
    }
    
    func setupAnimation() {
        guard let loadAnimation = loadAnimation else { return }
        view.addSubview(loadAnimation)
        loadAnimation.translatesAutoresizingMaskIntoConstraints = false
        loadAnimation.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadAnimation.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    func setupNavigationBar() {
        navigationBar = NavigationBar(for: self.view, navigationBarStyle: .black, tintColor: .white, title: "Rover Postcard Maker", leftButton: .back, rightButton: .controls, leftButtonAction: #selector(exit), rightButtonAction: #selector(showPicker))
        navigationBar?.load()
    }
    
    @objc func exit() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func showPicker() {
        marsFilter.open()
    }
    
    func addAction() {
        
        
        marsFilter.filterAction = {
            
            let selectedSol = self.marsFilter.sols[self.marsFilter.pickerView.selectedRow(inComponent: 0)]
            let selectedCamera = self.marsFilter.cameras[self.marsFilter.pickerView.selectedRow(inComponent: 1)]
            print(selectedSol)
            print(selectedCamera)
            
            
            self.client.getMarsImages(sol: selectedSol, camera: selectedCamera) { images, error in
                
                if let marsImageData = images {
                    
                    DispatchQueue.main.async {
                        self.images = marsImageData.photos
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
