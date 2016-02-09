//
//  Mock.swift
//  src
//
//  Created by Anil Kumar BP on 2/3/16.
//  Copyright © 2016 Anil Kumar BP. All rights reserved.
//

import Foundation

public class Mock: NSObject {
    
    internal var _path = ""
    internal var _method = "GET"
    internal var _status = 200
    internal var _json = [String: AnyObject]()
    internal var _headers = [String: String]()
    
    init(method: String = "GET", path: String = "", json: [String: AnyObject]?=nil, status: Int = 200) {
        self._method = method
        self._path = path
        self._json = json!
        self._status = status
        self._headers["Content-Type"] = "application/x-www-form-urlencoded;charset=UTF-8"
    }
    
    internal func response(request: NSMutableURLRequest) -> String {
        return self.createBody(self._json,status: self._status)
    }
    
    public func path() -> String {
        return self._path
    }
    
    public func method() -> String {
        return self._method
    }
    
    public func test(request:NSMutableURLRequest) {
        // TO-DO
    }
    
    public func getHeaders() -> [String: String] {
        return self._headers
    }
    
    internal func createBody(body: [String: AnyObject]?=nil, status: Int = 200, headers: [String: String]?=nil) -> String {
        var res: [String: AnyObject] = [:]
        res["HTTP/1.1"] = String(status)
        
        if let h = headers {
            
            for key in h.keys {
                res["key"] = h[key]
            }
        }
        
        res["Content-Type"] = "application/json"
        
        do {
//            let data = body!.dataUsingEncoding(NSUTF8StringEncoding)
            let data = try NSJSONSerialization.dataWithJSONObject(body!, options: [])
////            let data = body.toJsonString()
//            res["body"] = String(data: data, encoding: NSUTF8StringEncoding)
            res["body"] = data
        } catch {
            print("Exception with Mock")
        }
        //        res["body"] = NSJSONSerialization.dataWithJSONObject(body!, options: <#T##NSJSONWritingOptions#>)
        
        print("The respsone description is :", res.description)
        
        return res.description
    }
    
    
}
