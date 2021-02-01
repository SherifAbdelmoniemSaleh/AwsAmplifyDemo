//
//  UIViewExt.swift
//  Classmate_IOS
//
//  Created by Jihad Ismail on 10/30/17.
//  Copyright © 2017 Inova. All rights reserved.
//



import Foundation
import UIKit

extension UIView {
    
//    MARK:-  corner raduis
//    @IBInspectable var cornerRadius: CGFloat{
//        get{
//            return self.layer.cornerRadius
//        }
//        
//        set{
//            self.layer.cornerRadius = newValue
//            self.layer.masksToBounds = true
//        }
//    }
//    
//    MARK:- border width
    @IBInspectable var borderWidth: CGFloat{
        get{
            return self.layer.borderWidth
        }
        
        set{
            self.layer.borderWidth = newValue
        }
    }
    
//    MARK:- border color
    @IBInspectable var borderColor: UIColor?{
        get{
            let color = UIColor(cgColor: self.layer.borderColor!)
            return color
        }
        
        set{
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
//    MARK:- shadow
    @IBInspectable var shadowColor: UIColor?{
        get{
            let color = UIColor(cgColor: self.layer.shadowColor!)
            return color
        }
        
        set{
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowBluring: CGFloat{
        get{
            return self.layer.shadowRadius
        }
        
        set{
            self.layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize{
        get{
            return self.layer.shadowOffset
        }
        
        set{
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get{
            return self.layer.shadowOpacity
        }
        
        set{
            self.layer.shadowOpacity = newValue
        }
    }
    
    
    @IBInspectable var maskShadowToBounds: Bool {
        get{
            return self.layer.masksToBounds
        }
        
        set{
            self.layer.masksToBounds = newValue
        }
    }
    
// MARK:-  functions
    func setGradient (gradientColors: [CGColor], gradientLocations: [NSNumber]?, startPoint: CGPoint, endPoint: CGPoint ) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        
        if let lLocation  = gradientLocations {
            gradientLayer.locations = lLocation
        }
        
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.layoutIfNeeded()
    }
  
    func fadeIn() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    
    func fadeOut() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
    
    
    
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
        
    }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func createDotedBorder(width: CGFloat, color: UIColor) {
        let viewBorder = CAShapeLayer()
        viewBorder.strokeColor = color.cgColor
        viewBorder.lineDashPattern = [2, 2]
        viewBorder.frame = self.bounds
        viewBorder.fillColor = nil
        viewBorder.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(viewBorder)
    }
    
    func image() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    // MARK:- Make UIView hidden or visiable with its constraints
    func visiblity(gone: Bool, dimension: CGFloat = 0.0, attribute: NSLayoutConstraint.Attribute = .height) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = gone ? 0.0 : dimension
            self.isHidden = gone
            self.layoutIfNeeded()
        }
    }
    
      func roundCorners(corners: UIRectCorner, radius: CGFloat) {
              
              let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
              let mask = CAShapeLayer()
              mask.path = path.cgPath
              
              mask.backgroundColor = UIColor.red.cgColor
              self.layer.mask = mask
          }
}
