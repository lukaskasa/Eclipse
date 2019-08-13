//
//  HomeViewController.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 12.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var startStackView: UIStackView!
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) -> Void in
            
            let orientation = UIApplication.shared.statusBarOrientation
            
            if orientation.isPortrait {
                self.startStackView.axis = .vertical
            } else if orientation.isLandscape {
                self.startStackView.axis = .horizontal
            }
            
        }, completion: nil)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }


}

