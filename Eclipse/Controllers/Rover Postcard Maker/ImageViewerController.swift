//
//  ImageViewerController.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 07.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

/// Image Viewer Controller used to display a single mars rover image
class ImageViewerController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    var marsImage: MarsRoverImage!
    var indexPath: IndexPath!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if marsImage.state == .placeholder {
            downloadMarsImage(marsImage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup
        setImage()
        setupGestureRecognizer()
    }
    
    /// Set the image of asigned MarsRoverImage object
    func setImage() {
        imageView.image = marsImage.image
    }
    
    /// Setup a gesture recognizer to dismiss the view when swiping down
    func setupGestureRecognizer() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dissmissImageView))
        swipeRecognizer.direction = .down
        view.addGestureRecognizer(swipeRecognizer)
    }

    /// @objc dismiss the image view
    @objc func dissmissImageView() {
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Downloads and set the the marsImage
    
     - Parameters:
        - marsImage: The MarsRoverImage object with the image url
     
     - Returns: Void
     */
    func downloadMarsImage(_ marsImage: MarsRoverImage) {
        do {
            let data = try Data(contentsOf: URL(string: marsImage.imgSrc)!)
            marsImage.image = UIImage(data: data)
            setImage()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
