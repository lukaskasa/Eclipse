//
//  SelectedLocationAnnotationView.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 22.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import MapKit
//
//protocol Actionable: class {
//    func action(place: MKPlacemark, annotation: MKAnnotationView) -> (() -> Void)
//}

class SelectedLocationAnnotationView: MKAnnotationView {
    
    // Constants
    private let pinImage = UIImage(named: "nasa")
    private let animationDuration = 0.3
    
    weak var customCalloutView: LocationAnnotationView?
    var actionDelegate: EarthViewController?
    
    override var annotation: MKAnnotation? {
        willSet {
            customCalloutView?.removeFromSuperview()
        }
    }
    
    init(annotation: MKAnnotation?, reuseIdentifier: String?, actionDelegate: EarthViewController) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        self.image = pinImage
        self.actionDelegate = actionDelegate
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
        guard let views = Bundle.main.loadNibNamed(String(describing: LocationAnnotationView.self), owner: self, options: nil), let locationAnnotationView = views.first as? LocationAnnotationView else { return nil }
            
        if let locationAnnotation = annotation as? SelectedLocationAnnotation {
            
            let place = locationAnnotation.place
            
            locationAnnotationView.imageAction = actionDelegate?.action(place: place, annotation: self)
            
            locationAnnotationView.configureFor(place: place)
            locationAnnotationView.place = place
            
        }
        
        return locationAnnotationView
    }
    
}
