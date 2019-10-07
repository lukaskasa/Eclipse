//
//  MarsViewController.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 03.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

/// Controller to manage data flow for the Mars Rover Postcard Maker
class MarsViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    /// Constants
    private let dimViewTag = 20
    private let dimViewTransparancy = 0.6
    private let navBarTitle = "Rover Postcard Maker"
    let client = NASAClient()

    var navigationBar: NavigationBar?
    var loadAnimation: LoadAnimation!
    
    lazy var marsFilter = MarsImageryFilter(view: self.view)
    
    lazy var datasource: MarsImageryDatasource = {
        return MarsImageryDatasource(images: [], collectionView: self.collectionView)
    }()
    
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
    
    // Hide Status Bar
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
    
    /// Notifies the view controller that a segue is about to be performed.
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
    
    /// Setup the collection view by setting the delegate and datasource
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = datasource
    }
    
    /// Setup load animation
    func setupAnimation() {
        let dimView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        dimView.tag = dimViewTag
        view.addSubview(dimView)
        loadAnimation = LoadAnimation(for: self.view)
        view.addSubview(loadAnimation)
        loadAnimation.translatesAutoresizingMaskIntoConstraints = false
        loadAnimation.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadAnimation.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    /// Setup the navigation bar
    func setupNavigationBar() {
        navigationBar = NavigationBar(for: self.view, navigationBarStyle: .black, tintColor: .white, title: navBarTitle, leftButton: .back, rightButton: nil, leftButtonAction: #selector(exit), rightButtonAction: #selector(showPicker))
        navigationBar?.load()
    }
    
    /// @objc method to exit the current view controller
    @objc func exit() {
        dismiss(animated: true, completion: nil)
    }
    
    /// @objc method to open the mars image filter
    @objc func showPicker() {
        marsFilter.open()
    }
    
    /**
     Method to set the filteraction which fetches mars images upon selected criteria (sol & rover camera)
     
     - Returns: Void
     */
    func setFilterAction() {
        
        marsFilter.filterAction = {
            
            // Get selected sol and camera from the correct row
            let selectedSol = self.marsFilter.sols[self.marsFilter.pickerView.selectedRow(inComponent: 0)]
            let selectedCamera = self.marsFilter.cameras[self.marsFilter.pickerView.selectedRow(inComponent: 1)]
            
            self.loadAnimation?.start()
            self.view.viewWithTag(self.dimViewTag)?.isHidden = false
            self.navigationBar?.rightButton = nil
            
            // Fetch mars images using the selected sol and camera
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
