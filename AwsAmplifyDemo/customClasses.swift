//
//  customClasses.swift
//  AwsAmplifyDemo
//
//  Created by Sherif Abd El-Moniem on 01/02/2021.
//

import Foundation
import UIKit

@IBDesignable
class RoundedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
          get {
              return self.layer.cornerRadius
          }
          set {
              self.layer.cornerRadius = newValue
          }
      }
    
    @IBInspectable var cornerRadiusBottomOnly: Bool  {
        get {
            return self.layer.masksToBounds
        }
        set {
            if newValue == true {
                self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                //self.gradientLayer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        }
    }
    
    @IBInspectable var cornerRadiusTopOnly: Bool  {
        get {
            return self.layer.masksToBounds
        }
        set {
            if newValue == true {
                self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                //self.gradientLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
        }
    }
    
    @IBInspectable var BorderWidth: CGFloat  {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var BorderColor: UIColor?  {
        didSet {
            self.layer.borderColor = BorderColor?.cgColor
        }
    }
      
}
