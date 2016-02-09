//
//  MockClient.swift
//  src
//
//  Created by Anil Kumar BP on 2/1/16.
//  Copyright © 2016 Anil Kumar BP. All rights reserved.
//

import Foundation
import src


class MockClient: Client {
    
    internal var registry: MockRegistry
    
    // the constructor
    init(appName: String = "MockClient", appVersion: String = "1.0.0", mockRegistry: MockRegistry) {
        
        self.registry = mockRegistry
        super.init()
        
    }
    
    internal override func send(request: NSMutableURLRequest, completionHandler: (response: ApiResponse?, exception: NSException?) -> Void) {
        
//        var mock = self.registry.find(request)
    }
    
    
}