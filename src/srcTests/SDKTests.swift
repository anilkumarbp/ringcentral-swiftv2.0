//
//  SDKTest.swift
//  src
//
//  Created by Anil Kumar BP on 1/27/16.
//  Copyright © 2016 Anil Kumar BP. All rights reserved.
//

import XCTest
@testable import src




class sdkTests: XCTestCase {
    
    var rcsdk: SDK!
    var platform: Platform!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let app_key: String = "MNJx4H4cTR-02_zPnsTJ5Q"
        let app_secret = ""
        let username = "15856234190"
        let password = "sandman1!"
        
        
        rcsdk = SDK(appKey: app_key, appSecret: app_secret, server: SDK.RC_SERVER_SANDBOX, appName: "Swift_Test_Sample", appVersion: "1.0.0")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
//    
    func test_Constructor() {
        XCTAssertNotNil(rcsdk.getPlatform())
    }
    
    func testConnectToLiveServer(server: String) {
        do {
            
            let expectation = expectationWithDescription("get() does stuff and runs the callback closure")
//            rcsdk = SDK(appKey: "foo", appSecret: "bar" , server: server)
            try rcsdk.getPlatform().get(""){
                (apiresponse,apiexception) in
                let resp = apiresponse?.getDict()
                XCTAssertEqual("v1.0", resp!["uriString"])
                expectation.fulfill()
            }
        
            waitForExpectationsWithTimeout(1) { error in
                if let error = error {
                    XCTFail("waitForExpectationsWithTimeout errored: \(error)")
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func testProduction() {
        testConnectToLiveServer(SDK.RC_SERVER_PRODUCTION)
    }
    
    func testSandbox() {
        testConnectToLiveServer(SDK.RC_SERVER_SANDBOX)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

