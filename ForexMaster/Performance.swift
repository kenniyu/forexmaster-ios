//
//  Performance.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/23/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import ObjectMapper

public class Performance: Mappable {
    var date: NSDate!
    var profit: Double!
    
    required public init?(_ map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        profit        <- map["profit"]
        date        <- (map["date"], DateTransform())
    }
}

