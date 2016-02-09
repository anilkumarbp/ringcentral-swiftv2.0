//
//  MockRegistry.swift
//  src
//
//  Created by Anil Kumar BP on 2/3/16.
//  Copyright © 2016 Anil Kumar BP. All rights reserved.
//

import Foundation

public class MockRegistry {
    
    internal var responses = [Mock]()
    
    init() {
        //      self.responses = requestMockResponse as! [Mock]
    }
    
    // commenting for now { as swift does not support default constructors }
    func add(requestMockResponse: Mock) {
        self.responses = [requestMockResponse]
        print("Adding Mock to respsonses array : ")
        
    }
    
    func find(request: NSMutableURLRequest) -> Mock {
        let mock = self.responses.removeFirst()
        print("The mock removed is : ", mock._json)
        return mock
    }
    
    // Clear Mock
    public func clear() {
        return self.responses = []
    }
    
    // Authentication Mock
    public func authenticationMock() {
        let time = NSDate().timeIntervalSince1970 + 3600
        return self.add(Mock(method: "POST", path: "restapi/oauth/token", json: [
            "access_token": "ACCESS_TOKEN",
            "token_type": "bearer",
            "expires_in": "3600",
            "refresh_token": "REFRESH_TOKEN",
            "refresh_token_expires_in": "60480",
            "scope": "SMS RCM Foo Boo",
            "expireTime": String(time),
            "owner_id": "foo"
            ]))
    }
    
    // Logout Mock
    public func logoutMock() {
        return self.add(Mock(method: "POST", path: "/restapi/oauth/revoke"))
    }
    
    // Presence Subscription Mock
    public func presenceSubscriptionMock(id: String = "1", detailed: Bool = true) {
        
        let expiresIn = 15 * 60 * 60
        let time = NSDate().timeIntervalSince1970 + Double(expiresIn)
        
        return self.add(Mock(method: "POST", path: "/restapi/v1.0/subscription", json: [
            "eventFilters": ["/restapi/v1.0/account/~/extension/" , id , "/presence" , (detailed ? "?detailedTelephonyState=true" : "")],
            "expirationTime": String(time),
            "expiresIn": String(expiresIn),
            "deliveryMode": [
                "transportType": "PubNub",
                "encryption": "true",
                "address": "123_foo",
                "subscriberKey": "sub-c-foo",
                "secretKey": "sec-c-bar",
                "encryptionAlgorithm": "AES",
                "encryptionKey": "e0bMTqmumPfFUbwzppkSbA"
            ],
            "creationTime": String(NSDate()),
            "id": "foo-bar-baz",
            "status": "Active",
            "uri": "https://platform.ringcentral.com/restapi/v1.0/subscription/foo-bar-baz"
            ]))
    }
    
    public func refreshMock(failure: Bool = false, expiresIn: Int = 3600) {
        let time = NSDate().timeIntervalSince1970 + 3600
        var body = [String: AnyObject]()
        body = failure ? [
            "access_token": "ACCESS_TOKEN_FROM_REFRESH",
            "token_type": "bearer",
            "expires_in": String(expiresIn),
            "refresh_token": "REFRESH_TOKEN_FROM_REFRESH",
            "refresh_token_expires_in": "60480",
            "scope": "SMS RCM Foo Boo",
            "expireTime": String(time),
            "owner_id": "foo"
            ] : [
                "message": "Wrong Token (mock)"
        ]
        let status = !failure ? 200 : 400
        
        return self.add(Mock(method: "POST", path: "/restapi/oauth/token", json: body, status: status))
    }
    
    public func subscriptionMock(expiresIn: Int = 54000, eventFilters: [String] = ["/restapi/v1.0/account/~/extension/1/presence"]) {
        let expiresIn = 15 * 60 * 60
        let time = NSDate().timeIntervalSince1970 + Double(expiresIn)
        
        return self.add(Mock(method: "POST", path: "/restapi/v1.0/subscription", json: [
            "eventFilters": eventFilters,
            "expirationTime": String(time),
            "expiresIn": String(expiresIn),
            "deliveryMode": [
                "transportType": "PubNub",
                "encryption": "false",
                "address": "123_foo",
                "subscriberKey": "sub-c-foo",
                "secretKey": "sec-c-bar"
            ],
            "id": "foo-bar-baz",
            "creationTime": String(NSDate()),
            "status": "Active",
            "uri": "https://platform.ringcentral.com/restapi/v1.0/subscription/foo-bar-baz"
            ]))
    }
    
}
