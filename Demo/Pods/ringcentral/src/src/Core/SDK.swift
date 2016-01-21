//
//  SDK.swift
//  src
//
//  Created by Anil Kumar BP on 1/21/16.
//  Copyright © 2016 Anil Kumar BP. All rights reserved.
//

import Foundation

// Object representation of a Standard Development Kit for RingCentral
public class SDK {
    
    // Set constants for SANDBOX and PRODUCTION servers.
    public static var VERSION: String = ""
    public static var RC_SERVER_PRODUCTION: String = "https://platform.ringcentral.com"
    public static var RC_SERVER_SANDBOX: String = "https://platform.devtest.ringcentral.com"
    
    // Platform variable, version, and current Subscriptions
    var platform: Platform
    let server: String
    var client: Client
    var serverVersion: String!
    var versionString: String!
    var logger: Bool = false
    
    
    /// Constructor for the SDK object
    ///
    /// - parameter appKey:      The appKey of your app
    /// - parameter appSecet:    The appSecret of your app
    /// - parameter server:      Choice of PRODUCTION or SANDBOX
    /// @param: appName     appName ( optional )
    /// @param: appVersion  appVersion ( optional )
    public init(appKey: String, appSecret: String, server: String, appName: String?="", appVersion: String?="") {
        self.client = Client()
        platform = Platform(client: self.client, appKey: appKey, appSecret: appSecret, server: server, appName: appName!, appVersion: appVersion!)
        self.server = server
    }
    
    
    /// Returns the Platform with the specified appKey and appSecret.
    
    /// - returns: A Platform to access the methods of the SDK
    public func getPlatform() -> Platform {
        return self.platform
    }
    
    //  Create a subscription.
    
    //  :returns: Subscription object that has been currently created
    public func createSubscription() -> Subscription {
        return Subscription(platform: self.platform)
    }
    
    //  Create a multi-part builder
    public func createMultipartBuilder() -> MultipartBuilder {
        return MultipartBuilder()
    }
    
    
}

