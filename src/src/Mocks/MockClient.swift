//
//  MockClient.swift
//  src
//
//  Created by Anil Kumar BP on 2/3/16.
//  Copyright © 2016 Anil Kumar BP. All rights reserved.
//

import Foundation



class MockClient: Client {
    
    internal var registry: MockRegistry
    
    // the constructor
    init(appName: String = "MockClient", appVersion: String = "1.0.0", mockRegistry: MockRegistry) {
        
        self.registry = mockRegistry
        super.init()
        
    }
    
    internal override func send(request: NSMutableURLRequest, completionHandler: (response: ApiResponse?, exception: NSException?) -> Void) {
        
        let semaphore = dispatch_semaphore_create(0)
        let mock = self.registry.find(request)
        let apiresponse = ApiResponse(request: request, data: NSKeyedArchiver.archivedDataWithRootObject(mock.response(request)))
        completionHandler(response:apiresponse, exception: nil)
        dispatch_semaphore_signal(semaphore)
    }
    
    
}
