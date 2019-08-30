//
//  LocationAnnotationView.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 22.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import MapKit

// Constants
private let viewWidth: CGFloat = 210.0
private let viewHeight: CGFloat = 150.0
private let margin: CGFloat = 16.0
private let heightWidth: CGFloat = 40.0
private let animationDuration = 0.15
private let brandColor = UIColor(red: 0, green: 102/255, blue: 179/255, alpha: 1.0)

class LocationAnnotationView: UIView {
    
    // MARK: - Properties
    var place: MKPlacemark!
    var displayLink: CADisplayLink!
    var value: CGFloat = margin
    var invert = false
    
    var imageAction: (() -> Void)?
    
    lazy var backgroundViewButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        button.setTitle("", for: .normal)
        return button
    }()
    
    lazy var locationTitleLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.layer.borderWidth = 1.0
        label.layer.borderColor = UIColor.white.cgColor
        label.text = "No Location"
        label.textColor = .white
        return label
    }()
    
    lazy var getSateliteImageButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = brandColor
        button.tintColor = .white
        button.setTitle("Get satelite image", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        setupViews()
        setupConstraints()
        addAction()
        //self.applyArrowDialogAppearanceWithOrientation(arrowOrientation: .down, color: .black)
        self.sizeToFit()
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if let result = getSateliteImageButton.hitTest(convert(point, to: getSateliteImageButton), with: event) {
            return result
        }
        
        return backgroundViewButton.hitTest(convert(point, to: backgroundViewButton), with: event)
    }
    
    func setupViews() {
        self.addSubview(backgroundViewButton)
        self.addSubview(locationTitleLabel)
        self.addSubview(getSateliteImageButton)
    }
    
    func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        self.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        
        // Background View Button Constraints
        backgroundViewButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundViewButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        backgroundViewButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        backgroundViewButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        backgroundViewButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        
        // Location Title Label Constraints
        locationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        //locationTitleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 60.0).isActive = true
        locationTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0).isActive = true
        locationTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        //locationTitleLabel.bottomAnchor.constraint(equalTo: getSateliteImageButton.topAnchor, constant: -8.0).isActive = true
        locationTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        
        // Satelite Button Constraints
        getSateliteImageButton.translatesAutoresizingMaskIntoConstraints = false
        getSateliteImageButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        getSateliteImageButton.topAnchor.constraint(equalTo: locationTitleLabel.bottomAnchor, constant: 8.0).isActive = true
        getSateliteImageButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        getSateliteImageButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 40.0).isActive = true
        getSateliteImageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        

    }
    
    // MARK: - Action
    
    // MARK: - Helper
    
    func addAction() {
        getSateliteImageButton.addTarget(self, action: #selector(getSateliteImageAction), for: .touchUpInside)
    }
    
    @objc func getSateliteImageAction() {
        imageAction?()
    }
    
    func configureFor(place: MKPlacemark) {
        let city = place.locality ?? ""
        let country = place.country ?? ""
        locationTitleLabel.text = "\(city), \(country)"
    }
    
    // MARK: - Animation
    
//    func startAnimation() {
//        self.trailingButtonConstraint.isActive = false
//        self.getSateliteImageButton.setTitle("", for: .normal)
//
//        UIView.animate(withDuration: Constants.animationDuration) {
//            self.getSateliteImageButton.widthAnchor.constraint(equalToConstant: Constants.heightWidth).isActive = true
//            self.getSateliteImageButton.frame.size.width = Constants.heightWidth
//            self.getSateliteImageButton.frame.size.height = Constants.heightWidth
//            self.getSateliteImageButton.layer.cornerRadius = self.getSateliteImageButton.frame.size.width / 2.0
//        }
//
//        displayLink = CADisplayLink(target: self, selector: #selector(animateDisplay))
//        displayLink.add(to: RunLoop.main, forMode: .default)
//    }
//
//    func stopAnimation() {
//        displayLink.remove(from: RunLoop.main, forMode: .default)
//    }
    
    // MARK: - Selector Methods
    
//    @objc func animateDisplay() {
//        let viewWidth = self.frame.size.width - getSateliteImageButton.frame.size.width
//        invert ? (value -= 1) : (value += 1)
//        leadingButtonConstraint.constant = value
//
//        if value > viewWidth - Constants.margin || value < Constants.margin {
//            invert = !invert
//        }
//    }
    
}
