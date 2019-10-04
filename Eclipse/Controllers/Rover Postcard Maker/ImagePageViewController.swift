//
//  ImagePageViewController.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 06.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

private let dotColor = UIColor.red
private let brandColor = UIColor(red: 0, green: 102/255, blue: 179/255, alpha: 1.0)
private let dotBaseTag = 100

class ImagePageViewController: UIPageViewController {
    
    // MARK: - Properties
    
    var navigationBar: UINavigationBar!
    var navItem = UINavigationItem(title: "Mars Rover Image")
    var images: [MarsRoverImage] = []
    var imageIndexPath: IndexPath!
    var indexOfCurrentImage: Int!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup
        dataSource = self
        setupNavigationBar()
        setupPageIndicator(images.count)
        if let imageViewerController = imageViewerController(with: images[indexOfCurrentImage]) {
            setViewControllers([imageViewerController], direction: .forward, animated: true, completion: nil)
        }
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func imageViewerController(with image: MarsRoverImage) -> ImageViewerController? {
        guard let storyboard = storyboard, let imageViewerController = storyboard.instantiateViewController(withIdentifier: String(describing: ImageViewerController.self)) as? ImageViewerController else { return nil }
        
        imageViewerController.marsImage = image
        imageViewerController.indexPath = imageIndexPath
        
        return imageViewerController
    }
    
    func setupNavigationBar() {
        navigationBar = UINavigationBar()
        navigationBar.barStyle = .black
        navigationBar.tintColor = .white
        navigationBar.setItems([navItem], animated: true)
        
        navItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dissmissImageView))
        
        navItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "edit"), style: .plain, target: self, action: #selector(editPhoto))
        
        //navItem.title = marsImage.earthDate
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0.0).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0).isActive = true
    }
    
    func setActiveDot(with index: Int) {
        for tag in 0...images.count {
            view.viewWithTag(dotBaseTag + tag)?.backgroundColor = .none
        }
        
        view.viewWithTag(dotBaseTag + index)?.backgroundColor = brandColor
    }
    
    func setupPageIndicator(_ number: Int) {

        let dotView = UIStackView()
        
        dotView.axis = .horizontal
        dotView.alignment = .fill
        dotView.distribution = .fillEqually
        view.addSubview(dotView)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = brandColor.withAlphaComponent(0.3)
        
        dotView.addSubview(backgroundView)
        
        for index in 0..<number {
            let dot = self.bar(for: index)
            dotView.addArrangedSubview(dot)
            dot.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Set up constraints
        dotView.translatesAutoresizingMaskIntoConstraints = false
        dotView.heightAnchor.constraint(equalToConstant: 10.0).isActive = true
        dotView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        dotView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        dotView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0).isActive = true
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: dotView.topAnchor, constant: 0.0).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: dotView.bottomAnchor, constant: 0.0).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: dotView.leadingAnchor, constant: 0.0).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: dotView.trailingAnchor, constant: 0.0).isActive = true
        
        setActiveDot(with: indexOfCurrentImage)
    }
    
    func bar(for index: Int) -> UIView {
        let bar = UIView(frame: CGRect(x: 0, y: 0, width: 5.0, height: 10.0))
        bar.tag = dotBaseTag + index
        bar.backgroundColor = .none
        return bar
    }
    
    @objc func dissmissImageView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func editPhoto() {
        guard let storyboard = storyboard else { return }
        
        let editController = storyboard.instantiateViewController(withIdentifier: String(describing: ImageEditViewController.self)) as! ImageEditViewController
        
        editController.modalPresentationStyle = .fullScreen
        editController.modalTransitionStyle = .crossDissolve
        editController.marsImage = images[indexOfCurrentImage]
        
        present(editController, animated: true, completion: nil)
    }
    
}

extension ImagePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let imageVC = viewController as? ImageViewerController, let index = images.firstIndex(where: { $0.id == imageVC.marsImage.id }) else { return nil }
        
        indexOfCurrentImage = index
        setActiveDot(with: index)
        
        if index == images.startIndex {
            return nil
        } else {
            let indexBefore = images.index(before: index)
            let image = images[indexBefore]
            return imageViewerController(with: image)
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let imageVC = viewController as? ImageViewerController, let index = images.firstIndex(where: { $0.id == imageVC.marsImage.id }) else { return nil }
        
        indexOfCurrentImage = index
        setActiveDot(with: index)
        
        if index == images.index(before: images.endIndex) {
            return nil
        } else {
            let indexAfter = images.index(after: index)
            let image = images[indexAfter]
            return imageViewerController(with: image)
        }
        
    }
    
}
