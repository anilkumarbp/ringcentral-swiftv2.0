//
//  TestCase.swift
//  src
//
//  Created by Anil Kumar BP on 2/3/16.
//  Copyright © 2016 Anil Kumar BP. All rights reserved.
//


import XCTest
@testable import src

class TestCase: XCTestCase {

    
    var rcsdk: SDK!

    
    internal func getSDK(authorized: Bool = true) -> SDK {
        rcsdk = SDK(appKey: "whatever", appSecret: "whatever", server: "https://whatever", appName: "SDKTests", appVersion: SDK.VERSION, useHttpMock: authorized)
        if authorized {
            rcsdk.mockRegistry.authenticationMock()
            rcsdk.platform.login("18881112233", ext: "101", password: "password") {
                (apiresponse,apiexception) in
            }
        }
        return rcsdk
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
