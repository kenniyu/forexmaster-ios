//
//  Styles.swift
//
//  Created by Ken Yu on 1/31/15.
//  Copyright (c) 2015 Ken Yu. All rights reserved.
//

import UIKit

public class Styles {
    public class Colors {
        static let Green = UIColor(red: 0, green: 172.0/255.0, blue: 29.0/255.0, alpha: 1.0)
        static let Yellow = UIColor(red: 229/255.0, green: 168.0/255.0, blue: 2.0/255.0, alpha: 1.0)
        static let Blue = UIColor(red: 42/255.0, green: 133/255.0, blue: 245/255.0, alpha: 1.0)
        static let Red = UIColor(red: 255.0/255.0, green: 53.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        static let LightGray = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        static let Gray = UIColor(red: 120/255.0, green: 120/255.0, blue: 120/255.0, alpha: 1.0)
        static let Black = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
        
        static let White = UIColor.whiteColor()
    }
    
    public class Fonts {
        class func avenirBoldFontWithSize(size: CGFloat) -> UIFont! {
            return UIFont(name: "AvenirNext-Bold", size: size)
        }
        class func avenirRegularFontWithSize(size: CGFloat) -> UIFont! {
            return UIFont(name: "AvenirNext-Regular", size: size)
        }
        class func avenirItalicFontWithSize(size: CGFloat) -> UIFont! {
            return UIFont(name: "AvenirNext-Italic", size: size)
        }
        class func avenirMediumFontWithSize(size: CGFloat) -> UIFont! {
            return UIFont(name: "AvenirNext-Medium", size: size)
        }
        class func avenirBookFontWithSize(size: CGFloat) -> UIFont! {
            return UIFont(name: "Avenir-Book", size: size)
        }
        class func avenirDemiBoldFontWithSize(size: CGFloat) -> UIFont! {
            return UIFont(name: "AvenirNext-DemiBold", size: size)
        }
        class func avenirUltraLight(size: CGFloat) -> UIFont! {
            return UIFont(name: "AvenirNext-UltraLight", size: size)
        }
    }
    
    public class Dimensions {
        static let kItemSpacingDim1: CGFloat = 4
        static let kItemSpacingDim2: CGFloat = 8
        static let kItemSpacingDim3: CGFloat = 12
        static let kItemSpacingDim4: CGFloat = 16
        static let kItemSpacingDim5: CGFloat = 20
        static let kItemSpacingDim6: CGFloat = 24
        static let kItemSpacingDim7: CGFloat = 28
        static let kItemSpacingDim8: CGFloat = 32
        static let kItemSpacingDim9: CGFloat = 36
        static let kItemSpacingDim10: CGFloat = 40
        static let kItemSpacingDim11: CGFloat = 44
        static let kItemSpacingDim12: CGFloat = 48
    }
}
