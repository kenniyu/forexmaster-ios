//
//  ExperimentManager.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/20/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation


public struct ExperimentManagerKeys {
}

// Singleton
public class ExperimentManager {
    static let sharedInstance = ExperimentManager()
    public var showAds: Bool = false
    
    private init() {
        
    }
}