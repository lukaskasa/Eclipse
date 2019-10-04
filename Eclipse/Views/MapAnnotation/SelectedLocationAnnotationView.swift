//
//  SelectedLocationAnnotationView.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 22.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import MapKit

/// The custom annotation view to display a custom view for a location by a user
class SelectedLocationAnnotationView: MKAnnotationView {
    
    // MARK: - Properties
    private let pinImage = UIImage(named: "nasa")
    private let animationDuration = 0.3
    var actionDelegate: EarthViewController?
    weak var customCalloutView: LocationAnnotationView?
    
    override var annotation: MKAnnotation? {
        willSet {
            customCalloutView?.removeFromSuperview()
        }
    }
    
    /**
     Initializes a MKAnnotationView
     
     - Parameters:
        - annotation: The annotation used to display the annotation view for
        - reuseIdentifier: The resuseidentifier for the annotation view used to load view from queue
        - actionDelegate: The delegate controller used to asign the action to
     
     - Returns: A SelectedLocationAnnotationView object
     */
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
    
    /// Sets the selection state of the annotation view.
    /// Apple documentation:
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
    
    /// Called when the view is removed from the reuse queue.
    /// Apple documentation: https://developer.apple.com/documentation/mapkit/mkannotationview/1451907-prepareforreuse
    override func prepareForReuse() {
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
    }
    
    /// Returns the farthest descendant of the receiver in the view hierarchy (including itself) that contains a specified point.
    /// Apple documentation: https://developer.apple.com/documentation/uikit/uiview/1622469-hittest
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
    
    /**
     Configures and loads the LocationAnnotationView from the nib
     
     - Returns: A LocationAnnotationView
     */
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
