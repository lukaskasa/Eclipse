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
    @IBOutlet weak var eyeInTheSkyView: UIView!
    
    // MARK: - Properties
    //var window: UIWindow!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    // MARK: - Helper
    
    func resetNavigationBar() {
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window.rootViewController = self
//        window.makeKeyAndVisible()
    }
    
    func addGestureRecognizer() {
        
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(navigateToEyeInTheSky))
        eyeInTheSkyView.isUserInteractionEnabled = true
        eyeInTheSkyView.addGestureRecognizer(gestureRecogniser)
        
    }
    
    @objc func navigateToEyeInTheSky() {
        
        let earthViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: EarthViewController.self)) as! EarthViewController
        
        earthViewController.modalTransitionStyle = .crossDissolve

        present(earthViewController, animated: true, completion: nil)
        
    }

}

