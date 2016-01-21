//
//  CLient.swift
//  src
//
//  Created by Anil Kumar BP on 1/21/16.
//  Copyright © 2016 Anil Kumar BP. All rights reserved.
//


import Foundation


public class Client {
    
    // Client Variables
    internal var useMock: Bool = false
    internal var appName: String
    internal var appVersion: String
    internal var mockRegistry: AnyObject?
    
    // Client Constants
    var contentType = "Content-Type"
    var jsonContentType = "application/json"
    var multipartContentType = "multipart/mixed"
    var urlencodedContentType = "application/x-www-form-urlencoded"
    var utf8ContentType = "charset=UTF-8"
    var accept = "Accept"
    
    
    /// Constructor for the Client
    ///
    /// - parameter appName:        The appKey of your app
    /// - parameter appVersion:     The appSecret of your app
    init(appName: String = "", appVersion: String = "") {
        self.appName = appName
        self.appVersion = appVersion
    }
    
    
    /// Generic HTTP request with completion handler
    ///
    /// - parameter options:         List of options for HTTP request
    /// - parameter completion:      Completion handler for HTTP request
    /// @resposne: ApiResponse  Callback
    public func send(request: NSMutableURLRequest, completionHandler: (response: ApiResponse?, exception: NSException?) -> Void) {
        
        let semaphore = dispatch_semaphore_create(0)
        let task: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            
            (data, response, error) in
            let apiresponse = ApiResponse(request: request, data: data, response: response, error: error)
            // @success Handler
            if apiresponse.isOK() {
                completionHandler(response:apiresponse, exception: nil)
                dispatch_semaphore_signal(semaphore)
            }
                // @failure Handler
            else {
                completionHandler(response: apiresponse, exception: NSException(name: "HTTP Error", reason: "error", userInfo: nil))
                dispatch_semaphore_signal(semaphore)
            }
            
        }
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
    
    /// func createRequest()
    ///
    /// @param: method      NSMutableURLRequest
    /// @param: url         list of options
    /// @param: query       query ( optional )
    /// @param: body        body ( optional )
    /// @param: headers     headers
    /// @response: NSMutableURLRequest
    public func createRequest(method: String, url: String, query: [String: String]?=nil, body: [String: AnyObject]?, headers: [String: String]!) -> NSMutableURLRequest {
        
        var parse = parseProperties(method, url: url, query: query, body: body, headers: headers)
        
        // Create a NSMutableURLRequest
        var request = NSMutableURLRequest()
        if let nsurl = NSURL(string: url + (parse["query"] as! String)) {
            request = NSMutableURLRequest(URL: nsurl)
            request.HTTPMethod = method
            request.HTTPBody = parse["body"]!.dataUsingEncoding(NSUTF8StringEncoding)
            for (key,value) in parse["headers"] as! Dictionary<String, String> {
                print("key :",key, terminator: "")
                print("value :",value, terminator: "")
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
    
    // func parseProperties
    /// @param: method          NSMutableURLRequest
    /// @param: url             list of options
    /// @param: query           query ( optional )
    /// @param: body            body ( optional )
    /// @param: headers         headers
    /// @response: Dictionary
    internal func parseProperties(method: String, url: String, query: [String: String]?=nil, body: [String: AnyObject]?, headers: [String: String]!) -> [String: AnyObject] {
        
        var parse = [String: AnyObject]()
        var truncatedBodyFinal: String = ""
        var truncatedQueryFinal: String = ""
        var queryFinal: String = ""
        
        // Check for query
        if let q = query {
            queryFinal = "?"
            
            for key in q.keys {
                if(q[key] == "") {
                    queryFinal = "&"
                }
                else {
                    queryFinal = queryFinal + key + "=" + q[key]! + "&"
                }
            }
            truncatedQueryFinal = queryFinal.substringToIndex(queryFinal.endIndex.predecessor())
        }
        
        // Check for Body
        var bodyFinal: String = ""
        
        // Check if the body is empty
        if (body == nil || body?.count == 0) {
            truncatedBodyFinal = ""
        }
        else {
            if (headers["Content-type"] == "application/x-www-form-urlencoded;charset=UTF-8") {
                if let q = body {
                    bodyFinal = ""
                    for key in q.keys {
                        bodyFinal = bodyFinal + key + "=" + (q[key]! as! String) + "&"
                    }
                    truncatedBodyFinal = bodyFinal.substringToIndex(bodyFinal.endIndex.predecessor())
                }
            }
            else {
                if let json: AnyObject = body as AnyObject? {
                    bodyFinal = Util.jsonToString(json as! [String : AnyObject])
                    truncatedBodyFinal = bodyFinal
                }
            }
        }
        
        parse["query"] = truncatedQueryFinal
        parse["body"] = truncatedBodyFinal
        print("The body is :"+truncatedBodyFinal, terminator: "")
        parse["headers"] = [String: [String: String]]()
        // check for Headers
        if headers.count == 1 {
            var headersFinal = [String: String]()
            headersFinal["Content-Type"] = "application/json"
            headersFinal["Accept"] = "application/json"
            parse["headers"] = headersFinal
        }
        else {
            parse["headers"] = headers
        }
        return parse
    }
}




