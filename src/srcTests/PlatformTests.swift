//
//  PlatformTests.swift
//  src
//
//  Created by Anil Kumar BP on 1/31/16.
//  Copyright © 2016 Anil Kumar BP. All rights reserved.
//

import XCTest
@testable import src

class PlatformTests: XCTestCase {
    
    var rcsdk: SDK!
    var platform: Platform!
    
    // Test Case : Mock Class
    class SDKFake: SDK {
        func getSDK() {

        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin() {
        rcsdk
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
