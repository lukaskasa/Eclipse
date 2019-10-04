//
//  LocationAnnotationView.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 22.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import MapKit

class LocationAnnotationView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var backgroundViewButton: UIButton!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var getSateliteImageButton: UIButton!
    
    // MARK: - Properties
    
    private let viewWidth: CGFloat = 210.0
    private let viewHeight: CGFloat = 150.0
    private let heightWidth: CGFloat = 36.0
    private let animationDuration = 2.0
    private let brandColor = UIColor(red: 0, green: 102/255, blue: 179/255, alpha: 1.0)
    
    var place: MKPlacemark!
    var imageAction: (() -> Void)?
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Setup
        self.backgroundColor = .clear
        backgroundViewButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.applyArrowDialogAppearanceWithOrientation(arrowOrientation: .down, color: .black)
    }
    
    /// Returns the farthest descendant of the receiver in the view hierarchy (including itself) that contains a specified point.
    /// Apple documentation: https://developer.apple.com/documentation/uikit/uiview/1622469-hittest
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if let result = getSateliteImageButton.hitTest(convert(point, to: getSateliteImageButton), with: event) {
            return result
        }
        
        return backgroundViewButton.hitTest(convert(point, to: backgroundViewButton), with: event)
    }

    // MARK: - Action
    
    /// Fires the image action asigned to the Annotationview
    @IBAction func getSateliteImage(_ sender: Any) {
        imageAction?()
    }
    
    // MARK: - Helper
    
    /// Configure the placemark with the city and country
    func configureFor(place: MKPlacemark) {
        if let city = place.locality, let country = place.country {
            locationTitleLabel.text = "\(city), \(country)"
        } else if let title = place.title {
            locationTitleLabel.text = title
        }
    }
    
}
