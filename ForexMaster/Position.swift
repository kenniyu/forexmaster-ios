//
//  Position.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/19/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import ObjectMapper

public class Position: Mappable {
    var pair: String!
    var size: Int!
    var costBasis: String!
    
    required public init?(_ map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        pair        <- map["pair"]
        size       <- map["size"]
        costBasis          <- map["cost_basis"]
    }
}