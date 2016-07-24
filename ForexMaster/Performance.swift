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
    var closedTrades: [ClosedTrade] = []
    var initialBalance: Double!
    var inceptionDate: NSDate!
    var settledProfits: Double!
    var returnPct: Double!
    
    required public init?(_ map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        closedTrades <- map["closed_trades"]
        initialBalance <- map["initial_balance"]
        inceptionDate <- (map["inception_date"], DateTransform())
        settledProfits <- map["settled_profits"]
        returnPct <- map["total_return"]
    }
}

