//
//  Util.swift
//  src
//
//  Created by Anil Kumar BP on 1/21/16.
//  Copyright © 2016 Anil Kumar BP. All rights reserved.
//


import Foundation
import SwiftyJSON

public class Util {
    
    
    /// func jsonToString()
    ///
    /// @param: json        Json Object
    /// @response           String
    static func jsonToString(json: [String: AnyObject]) -> String {
        
        let resultJSON = JSON(json)
        let result = resultJSON.rawString()!
//        var result = "{"
//        var delimiter = ""
//        for key in json.keys {
//            result += delimiter + "\"" + key + "\":"
//            let item: AnyObject? = json[key]
//            if let check = item as? String {
//                result += "\"" + check + "\""
//            } else {
//                if let check = item as? [String: AnyObject] {
//                    result += jsonToString(check)
//                } else if let check = item as? [AnyObject] {
//                    result += "["
//                    delimiter = ""
//                    for item in check {
//                        result += "\n"
//                        result += delimiter + "\""
//                        result += item.description + "\""
//                        delimiter = ","
//                    }
//                    result += "]"
//                } else {
//                    result += item!.description
//                }
//            }
//            delimiter = ","
//        }
//        result = result + "}"
        return result
    }
}
