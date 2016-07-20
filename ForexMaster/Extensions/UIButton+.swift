//
//  UIButton+.swift
//  Stellar
//
//  Created by Ken Yu on 2/29/16.
//  Copyright © 2016 Stellar. All rights reserved.
//

import Foundation
import UIKit

public enum ButtonStyle {
    case Primary
    case Secondary
    case Bordered
}

extension UIButton {
    public func applyBorder(borderWidth: CGFloat, color: UIColor? = nil) {
        self.borderWidth = borderWidth
        self.borderColor = color ?? tintColor
    }
    
    public func applyFill(normalColor: UIColor, disabledColor: UIColor? = nil) {
        setBackgroundImage(UIImage().imageWithColor(normalColor, size: frame.size), forState: .Normal)
        
        if let disabledColor = disabledColor {
            setBackgroundImage(UIImage().imageWithColor(disabledColor, size: frame.size), forState: .Disabled)
        } else {
            setBackgroundImage(UIImage().imageWithColor(normalColor, size: frame.size), forState: .Disabled)
        }
    }
    
    public func applyStyle(buttonStyle: ButtonStyle) {
        titleLabel?.font = Styles.Fonts.avenirMediumFontWithSize(16)
        setTitle(titleLabel?.text, forState: .Normal)
        cornerRadius = 1
        layer.masksToBounds = true
        
        switch buttonStyle {
        case .Primary:
            tintColor = Styles.Colors.White
            applyFill(Styles.Colors.Blue.colorWithAlphaComponent(0.9))
            applyBorder(0)
        case .Secondary:
            tintColor = UIColor.blackColor()
            applyFill(Styles.Colors.LightGray.colorWithAlphaComponent(0.9))
            applyBorder(0)
        case .Bordered:
            applyFill(UIColor.clearColor())
            applyBorder(1)
        }
    }
}














//
//
//
//loop through all letters of the string
//so, string[i] is the reference to the current letter of the for loop
//then, see if string[i] is inside our array of vowels, by doing this:
//    array.indexOf(string[i])
//    if array contains string[i], then the above method will return a value >= 0
//    if array does not contain string[i], then the above method will return -1
//
//
//
//
//
//
//
