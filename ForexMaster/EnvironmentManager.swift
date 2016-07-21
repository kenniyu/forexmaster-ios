//
//  EnvironmentManager.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/21/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation

public struct EnvironmentManagerKeys {
    static let kConfigurationKey = "Configuration"
    static let kResourcePathName = "Environments"
    static let kBaseUrlKey = "baseUrl"
}

public class EnvironmentManager {
    static let sharedInstance = EnvironmentManager()
    
    public var baseUrl: String
    
    private init() {
        let bundle = NSBundle.mainBundle()
        
        if let infoDictionary = bundle.infoDictionary,
            configuration = infoDictionary[EnvironmentManagerKeys.kConfigurationKey],
            envPropertyFilePath = bundle.pathForResource(EnvironmentManagerKeys.kResourcePathName, ofType: "plist"),
            environments = NSDictionary(contentsOfFile: envPropertyFilePath),
            environment = environments.objectForKey(configuration) {
            if let baseUrl = environment.valueForKey(EnvironmentManagerKeys.kBaseUrlKey) as? String {
                self.baseUrl = baseUrl
                return
            }
        }
        baseUrl = "http://localhost:3000"
    }
}