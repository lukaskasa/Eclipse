//
//  UIView.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 22.08.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

/// Credit: https://github.com/DigitalLeaves/YourPersonalWishlist/blob/master/CustomPinsMap/UIView%2BBezierPaths.swift
extension UIView {
    
    /// Convert Degrees to Radians
    func degreesToRadians (_ value:CGFloat) -> CGFloat {
        return value * CGFloat(Double.pi) / 180.0
    }
    
    /// Convert Radians to Degrees
    func radiansToDegrees (_ value:CGFloat) -> CGFloat {
        return value * 180.0 / CGFloat(Double.pi)
    }
    
    func dialogBezierPathWithFrame(_ frame: CGRect, arrowOrientation orientation: UIImage.Orientation, arrowLength: CGFloat = 20.0) -> UIBezierPath {
        // Translate frame to neutral coordinate system & transpose it to fit the orientation.
        var transposedFrame = CGRect.zero
        switch orientation {
        case .up, .down, .upMirrored, .downMirrored:
            transposedFrame = CGRect(x: 0, y: 0, width: frame.size.width - frame.origin.x, height: frame.size.height - frame.origin.y)
        case .left, .right, .leftMirrored, .rightMirrored:
            transposedFrame = CGRect(x: 0, y: 0,  width: frame.size.height - frame.origin.y, height: frame.size.width - frame.origin.x)
        @unknown default:
            fatalError()
        }
        
        // We need 7 points for our Bezier path
        let midX = transposedFrame.midX
        let point1 = CGPoint(x: transposedFrame.minX, y: transposedFrame.minY + arrowLength)
        let point2 = CGPoint(x: midX - (arrowLength / 2), y: transposedFrame.minY + arrowLength)
        let point3 = CGPoint(x: midX, y: transposedFrame.minY)
        let point4 = CGPoint(x: midX + (arrowLength / 2), y: transposedFrame.minY + arrowLength)
        let point5 = CGPoint(x: transposedFrame.maxX, y: transposedFrame.minY + arrowLength)
        let point6 = CGPoint(x: transposedFrame.maxX, y: transposedFrame.maxY)
        let point7 = CGPoint(x: transposedFrame.minX, y: transposedFrame.maxY)
        
        // Build our Bezier path
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.addLine(to: point4)
        path.addLine(to: point5)
        path.addLine(to: point6)
        path.addLine(to: point7)
        path.close()
        
        // Rotate our path to fit orientation
        switch orientation {
        case .up, .upMirrored:
        break // do nothing
        case .down, .downMirrored:
            path.apply(CGAffineTransform(rotationAngle: degreesToRadians(180.0)))
            path.apply(CGAffineTransform(translationX: transposedFrame.size.width, y: transposedFrame.size.height))
        case .left, .leftMirrored:
            path.apply(CGAffineTransform(rotationAngle: degreesToRadians(-90.0)))
            path.apply(CGAffineTransform(translationX: 0, y: transposedFrame.size.width))
        case .right, .rightMirrored:
            path.apply(CGAffineTransform(rotationAngle: degreesToRadians(90.0)))
            path.apply(CGAffineTransform(translationX: transposedFrame.size.height, y: 0))
        @unknown default:
            fatalError()
        }
        
        return path
    }
    
    /// Draws an arrow for the given UIView
    func applyArrowDialogAppearanceWithOrientation(arrowOrientation: UIImage.Orientation, color: UIColor) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = dialogBezierPathWithFrame(self.frame, arrowOrientation: arrowOrientation).cgPath
        shapeLayer.fillColor = color.cgColor
        shapeLayer.fillRule = CAShapeLayerFillRule.evenOdd
        self.layer.mask = shapeLayer
    }
    
}
