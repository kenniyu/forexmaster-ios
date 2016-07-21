//
//  NetworkManager.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/21/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation

public class NetworkManager {
    static let sharedInstance = NetworkManager()
    public var baseUrl = "https://fast-forest-93779.herokuapp.com"
    // "http://localhost:3000"
    
//     https://fast-forest-93779.herokuapp.com
    
    private init() {
        let environmentBaseUrl = EnvironmentManager.sharedInstance.baseUrl
        baseUrl = environmentBaseUrl
    }
}
