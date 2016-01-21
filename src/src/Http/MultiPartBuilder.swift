//
//  MultiPartBuilder.swift
//  src
//
//  Created by Anil Kumar BP on 1/21/16.
//  Copyright © 2016 Anil Kumar BP. All rights reserved.
//


import Foundation

public class MultipartBuilder {
    
    internal var body = String()
    internal var _contents = [String: AnyObject]()
    internal var _boundary: String?
    
    // Set the Boundary
    public func setBoundary(boundary: String = "") {
        self._boundary = boundary
    }
    
    // Boundary, return the boundary
    public func boundary() -> String {
        return self._boundary!
    }
    
    // Set Body for the MultiPart
    public func setBody(body: [String: AnyObject]) -> MultipartBuilder {
        self.body = jsonToString(body)
        return self
    }
    
    // Retreive body
    public func getBody() -> String {
        return self.body
    }
    
    // Function always use provided $filename. In cases when it's empty, for string content or when name cannot be
    // Automatically discovered the $filename will be set to attachment name.
    // If attachment name is not provided, it will be randomly generated.
    public func add(content: AnyObject, fileName: String = "", headers: [String: String]?=nil , name: String = "") -> MultipartBuilder {
        
        var element: [String: AnyObject] = ["":""]
        // If file content is a string
        if(content is String){
            element["contents"] = content
        }
        
        // If content is a NSURL
        if(content is NSURL){
            
            //            let fileName = (content.path!! as NSString).lastPathComponent
            //            let mimeType = "text/csv"
            //            let fieldName = "uploadFile"
            element["contents"] = try! String(contentsOfFile: content.path!!, encoding: NSUTF8StringEncoding)
        }
        self._contents = element
        
        return self
    }
    
    // Get the contents
    public func contents() -> [String:AnyObject] {
        return self._contents
    }
    
    // Create a request
    public func request(url: String, method: String = "POST", completion: (respsone: ApiResponse) -> Void) {
        
        let uniqueId = NSProcessInfo.processInfo().globallyUniqueString
        let boundaryConstant = "Boundary-"+uniqueId
        
        var headers: [String: String] = [:]
        headers["Content-type"] = "application/octet-stream; boundary=" + boundaryConstant
        
        let fileName: AnyObject? = self._contents["filename"]
        let contents: AnyObject? = self._contents["contents"]
        let mimeType = "application/octet-stream"
        let fieldName = "uploadFile"
        
        
        var dataString = "--\(boundaryConstant)\r\n"
        dataString += "Content-Type: application/json\r\n"
        dataString += "Content-Disposition: form-data; name=\"json\"; filename=\"request.json\"\r\n"
        dataString += "Content-Length: 51\r\n"
        dataString += "\r\n"
        dataString += "{\"to\":{\"phoneNumber\":\"foo\"},\"faxResolution\":\"High\"}\r\n"
        dataString += "--\(boundaryConstant)--\r\n"
        dataString += "Content-Type: \(mimeType)\r\n\r\n"
        dataString += "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n"
        dataString += String(stringInterpolationSegment: contents)
        dataString += "\r\n"
        dataString += "--\(boundaryConstant)--\r\n"
        
    }
    
    
    public func jsonToString(json: [String: AnyObject]) -> String {
        var result = "{"
        var delimiter = ""
        for key in json.keys {
            result += delimiter + "\"" + key + "\":"
            let item: AnyObject? = json[key]
            if let check = item as? String {
                result += "\"" + check + "\""
            } else {
                if let check = item as? [String: AnyObject] {
                    result += jsonToString(check)
                } else if let check = item as? [AnyObject] {
                    result += "["
                    delimiter = ""
                    for item in check {
                        result += "\n"
                        result += delimiter + "\""
                        result += item.description + "\""
                        delimiter = ","
                    }
                    result += "]"
                } else {
                    result += item!.description
                }
            }
            delimiter = ","
        }
        result = result + "}"
        
        print("Body String is :"+result, terminator: "")
        return result
    }
    
}

