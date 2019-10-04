//
//  SateliteImageView.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 28.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

/// Modal UIView to display the satelite image in
class SateliteImageView: UIView {
    
    // MARK: - Properties
    private let primaryFont: UIFont = UIFont(name: "Futura", size: 17.0)!
    private let brandColor = UIColor(red: 0, green: 102/255, blue: 179/255, alpha: 1.0)
    private let secondaryColor = UIColor(red: 238/255, green: 22/255, blue: 31/255, alpha: 1.0)
    
    var saveAction: (() -> Void)?
    var cancelAction: (() -> Void)?

    lazy var imageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0))
        return view
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedString = NSAttributedString(string: "Save", attributes: [NSAttributedString.Key.font: primaryFont])
        button.setAttributedTitle(attributedString, for: .normal)
        button.backgroundColor = brandColor
        button.tintColor = .white
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedString = NSAttributedString(string: "Cancel", attributes: [NSAttributedString.Key.font: primaryFont])
        button.setAttributedTitle(attributedString, for: .normal)
        button.backgroundColor = secondaryColor
        button.tintColor = .white
        return button
    }()
     
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(saveButton)
        stackView.addArrangedSubview(cancelButton)
        return stackView
    }()
    
    /**
     Initializes a Earth Satelite image view
     
     - Parameters:
        - frame: The CGRect used to determine size and position of the view
     
     - Returns: A SateliteImageView
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        setupViews()
        setupConstraints()
        addActions()
    }
    
    // Convenience initializer used with default size values
    convenience init(width: CGFloat = 256.0, height: CGFloat = 298.0) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Setup the subviews
    func setupViews() {
        self.addSubview(imageView)
        self.addSubview(buttonStackView)
    }
    
    /// Setup the constraints
    func setupConstraints() {
        // Main View
        self.translatesAutoresizingMaskIntoConstraints = false
        setupImageViewConstraints()
        setStackViewConstraints()
    }
    
    /// Setup image View constraints
    fileprivate func setupImageViewConstraints() {
        // Image View Constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 256.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 256.0).isActive = true
    }
    
    /// Setup Stack View constraints
    fileprivate func setStackViewConstraints() {
        // Button Constraints
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        buttonStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0).isActive = true
        buttonStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        buttonStackView.heightAnchor.constraint(equalToConstant: 42.0).isActive = true
    }
    
    /// Asign actions to the buttons accordingly
    func addActions() {
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
    }
    
    /// Cancel action
    @objc func cancel() {
        cancelAction?()
    }
    
    /// Save action
    @objc func save() {
        saveAction?()
    }
    
}
