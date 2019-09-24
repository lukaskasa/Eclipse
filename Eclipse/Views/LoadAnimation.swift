//
//  LoadAnimation.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 05.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

class LoadAnimation: UIView {
    
    private var animator: UIViewPropertyAnimator!
    private let nasaLogo = UIImage(named: "nasa")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(for view: UIView) {
        self.init(frame: CGRect(x: 0, y: 0, width: 50.0, height: 50.0))
        setupViews()
        initAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = self.frame.width / 2.0
        setupImageView()
    }
    
    private func setupImageView() {
        let imageView = UIImageView(image: nasaLogo)
        self.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0).isActive = true
     }
    
    private func initAnimation(_ reversed: Bool = false) {
        
        animator = UIViewPropertyAnimator(
            duration: 1.5, timingParameters: UICubicTimingParameters())
        
        animator.addAnimations {
            self.transform = CGAffineTransform(scaleX: reversed ? 0.5 : 1.0, y: reversed ? 0.5 : 1.0)
        }
        
        animator.addCompletion { _ in
            self.initAnimation(!reversed)
        }
        
        animator.startAnimation()
    }
    
    func start() {
        self.isHidden = false
        animator.startAnimation()
    }
    
    func stop() {
        animator = nil
        self.isHidden = true
    }
    
}
