//
//  Message.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/25/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation

import ObjectMapper

public class Message: Mappable {
    var body: String!
    var date: NSDate!
    
    required public init?(_ map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        body        <- map["body"]
        date        <- (map["date"], DateTransform())
    }
}