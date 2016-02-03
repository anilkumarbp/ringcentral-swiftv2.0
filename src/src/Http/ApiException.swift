//
//  ApiException.swift
//  src
//
//  Created by Anil Kumar BP on 1/29/16.
//  Copyright © 2016 Anil Kumar BP. All rights reserved.
//

import Foundation

public class ApiException: ErrorType {
    
    private var _apiresponse: ApiResponse!
    
    /// Constructor for the ApiException
    ///
    /// @param: request     NSMutableURLRequest
    /// @param: data        Instance of NSData
    /// @param: response    Instance of NSURLResponse
    /// @param: error       Instance of NSError
    init(apiresponse: ApiResponse?, error: NSException?) {
        self._apiresponse = apiresponse
        var statusCode: Int
        var message = (error != nil) ? error?.description: "Uknown Error"
        if (apiresponse != nil) {
            if (apiresponse?.getError() != nil) {
                message = apiresponse?.getError() as? String
            }
            //            if ((apiresponse?.getResponse()!=nil) && statusCode = (apiresponse?.getResponse() as! NSHTTPURLResponse.StatusCode)){
            //                var status = apiresponse?.getResponse() as! NSHTTPURLResponse.StatusCode
            //            }
        }
    }
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


