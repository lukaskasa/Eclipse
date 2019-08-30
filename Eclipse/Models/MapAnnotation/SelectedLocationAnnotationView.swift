//
//  SelectedLocationAnnotationView.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 22.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import MapKit

class SelectedLocationAnnotationView: MKAnnotationView {
    
    // Constants
    private let pinImage = UIImage(named: "nasa")
    private let animationDuration = 0.3
    let client = NASAClient()
    
    weak var customCalloutView: LocationAnnotationView?
    
    override var annotation: MKAnnotation? {
        willSet {
            customCalloutView?.removeFromSuperview()
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        self.image = pinImage
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false
        self.image = pinImage
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            // Remove Default View
            self.customCalloutView?.removeFromSuperview()
            
            if let newCustomCalloutView = loadLocationDetailConfigView() {
                
                // Location ajustments from top-left
                
                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
                
                self.layer.borderWidth = 1.0
                self.layer.borderColor = UIColor.blue.cgColor
                
                // Set Custom View
                self.addSubview(newCustomCalloutView)
                self.customCalloutView = newCustomCalloutView
                
                if animated {
                    
                    self.customCalloutView!.alpha = 0.0
                    
                    UIView.animate(withDuration: animationDuration) {
                        self.customCalloutView!.alpha = 1.0
                        self.customCalloutView!.layer.cornerRadius = 4.0
                    }
                    
                }
                
            }
            
        } else {
            if customCalloutView != nil {
                
                if animated {
                    
                    UIView.animate(withDuration: animationDuration, animations: {
                        self.customCalloutView?.alpha = 0.0
                    }, completion: { success in
                        self.customCalloutView?.removeFromSuperview()
                    })
                    
                } else {
                    self.customCalloutView?.removeFromSuperview()
                }
                
            }
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let parentHitView = super.hitTest(point, with: event) {
            return parentHitView
        } else {
            if customCalloutView != nil {
                return customCalloutView!.hitTest(convert(point, to: customCalloutView!), with: event)
            } else {
                return nil
            }
        }
        
    }
    
    // MARK: - Helper
    
    private func loadLocationDetailConfigView() -> LocationAnnotationView? {
        let locationAnnotationView = LocationAnnotationView()
            
        if let locationAnnotation = annotation as? SelectedLocationAnnotation {
            
            let place = locationAnnotation.place
            
            locationAnnotationView.imageAction = action(place: place)
            
            locationAnnotationView.configureFor(place: place)
            locationAnnotationView.place = place
            
        }
        
        return locationAnnotationView
    }
    
    private func action(place: MKPlacemark) -> (() -> Void) {
        
        let action = { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.client.getEarthImageData(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude) { data, error in
                
                DispatchQueue.main.async {
                    
                    let view = SateliteImageView()
                    
                    if let data = data {
                        
                        strongSelf.client.getImage(earthImageJSON: data) { imageData, error in
                            
                            DispatchQueue.main.async {
                                guard let imageData = imageData, let image = UIImage(data: imageData), let superview = self?.superview else { return }
                                view.imageView.image = image
                                superview.addSubview(view)
                                view.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
                                view.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
                            }
     
                        }
                        
                        
                    }
                }
                
            }
            
        }
        
        return action
    }
    
    
    
}
