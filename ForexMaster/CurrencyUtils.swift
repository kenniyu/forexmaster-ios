//
//  CurrencyUtils.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/21/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation

final public class CurrencyUtils {
    public static func toCurrencyString(amount: Double, maximumFractionDigits: Int = 2) -> String {
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        currencyFormatter.maximumFractionDigits = maximumFractionDigits
        if let amountStr = currencyFormatter.stringFromNumber(amount) {
            return amountStr
        }
        return String(amount)
    }
    
    public static func toCurrencyString(amount: Int, maximumFractionDigits: Int = 2) -> String {
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        currencyFormatter.maximumFractionDigits = maximumFractionDigits
        if let amountStr = currencyFormatter.stringFromNumber(amount) {
            return amountStr
        }
        return String(amount)
    }
}
