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
private let heightWidth: CGFloat = 36.0
private let animationDuration = 2.0
private let brandColor = UIColor(red: 0, green: 102/255, blue: 179/255, alpha: 1.0)

class LocationAnnotationView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var backgroundViewButton: UIButton!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var getSateliteImageButton: UIButton!
    
    // MARK: - Properties
    
    var place: MKPlacemark!
    var displayLink: CADisplayLink!
    var value: CGFloat = heightWidth
    var invert = false
    
    var imageAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        backgroundViewButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.applyArrowDialogAppearanceWithOrientation(arrowOrientation: .down, color: .black)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if let result = getSateliteImageButton.hitTest(convert(point, to: getSateliteImageButton), with: event) {
            return result
        }
        
        return backgroundViewButton.hitTest(convert(point, to: backgroundViewButton), with: event)
    }

    // MARK: - Action
    @IBAction func getSateliteImage(_ sender: Any) {
        imageAction?()
    }
    
    // MARK: - Helper

    func configureFor(place: MKPlacemark) {
        if let city = place.locality, let country = place.country {
            locationTitleLabel.text = "\(city), \(country)"
        } else if let title = place.title {
            locationTitleLabel.text = title
        }
    }
    
}
