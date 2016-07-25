//
//  Trade.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/20/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import ObjectMapper

public class Trade: Mappable {
    var pair: String!
    var size: Int!
    var mark: String!
    var date: NSDate!
    var status: Int!
    
    required public init?(_ map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        pair        <- map["pair"]
        size        <- map["size"]
        mark        <- map["mark"]
        status        <- map["status"]
        date        <- (map["date"], DateTransform())
    }
}