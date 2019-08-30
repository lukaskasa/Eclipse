//
//  SateliteImageView.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 28.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

// Constants
private let viewWidth: CGFloat = 256.0
private let viewHeight: CGFloat = 298.0
private let brandColor = UIColor(red: 0, green: 102/255, blue: 179/255, alpha: 1.0)

class SateliteImageView: UIView {
    
    // MARK: - Properties

    
    lazy var imageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0))
        return view
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = brandColor
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        setupViews()
        setupConstraints()
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(imageView)
        self.addSubview(saveButton)
    }
    
    func setupConstraints() {
        // Main View
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Image View Constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        //imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 256.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 256.0).isActive = true
        
        setSaveButtonConstraints()
    }
    
    fileprivate func setSaveButtonConstraints() {
        // Button Constraints
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        saveButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0).isActive = true
        saveButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 42.0).isActive = true
    }
    
}
