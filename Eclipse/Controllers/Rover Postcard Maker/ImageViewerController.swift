//
//  ImageViewerController.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 07.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

class ImageViewerController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    var marsImage: MarsImage!
    var indexPath: IndexPath!
    
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setImage() {
        imageView.image = marsImage.image
    }
    
    func setupGestureRecognizer() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dissmissImageView))
        swipeRecognizer.direction = .down
        view.addGestureRecognizer(swipeRecognizer)
    }

    @objc func dissmissImageView() {
        dismiss(animated: true, completion: nil)
    }
    
    func downloadMarsImage(_ marsImage: MarsImage) {
        do {
            let data = try Data(contentsOf: URL(string: marsImage.imgSrc)!)
            marsImage.image = UIImage(data: data)
            setImage()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
