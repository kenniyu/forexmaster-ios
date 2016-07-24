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
    var trades: [ClosedTrade] = []
    
    required public init?(_ map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        trades <- map["performance"]
    }
}

