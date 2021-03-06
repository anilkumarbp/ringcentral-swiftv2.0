//
//  ViewController.swift
//  Demo
//
//  Created by Anil Kumar BP on 1/21/16.
//  Copyright © 2016 Anil Kumar BP. All rights reserved.
//

import UIKit
import ringcentral

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let app_key: String = "MNJx4H4cTR-02_zPnsTJ5Q"
        let app_secret = "7CJKigzBTzOvzTDPP1-C3AARDYohOlSaCLcvgzpNZUzw"
        let username = "15856234190"
        let password = "sandman1!"
        
        
        let rcsdk = SDK(appKey: app_key, appSecret: app_secret, server: SDK.RC_SERVER_SANDBOX, appName: "Swift_Test_Sample", appVersion: "1.0.0")
        print("SDK initialized")
        let platform = rcsdk.getPlatform()
        let subscription = rcsdk.createSubscription()
        //var multipartBuilder = rcsdk.createMultipartBuilder()
        print("Platform singleton")
        
        // login
        
        platform.login(username, ext:"101", password: password)
            {
                (apiresponse,apiexception) in
                print("Response is :")
                print(apiresponse!.JSONStringify(apiresponse!.getDict(), prettyPrinted: true))
        }
        // Test a GET request
        
        platform.refresh()
            {
                (apiresponse,apiexception) in
                print("Response is :")
                print(apiresponse!.JSONStringify(apiresponse!.getDict(), prettyPrinted: true))
        }
        
        platform.get("/account/~/extension/~/call-log")
            {
                (apiresponse,apiexception) in
                print("Response is :")
                print(apiresponse!.JSONStringify(apiresponse!.getDict(), prettyPrinted: true))
        }
        
        //         add events to the subscription object
        subscription.addEvents(
            [
                "/restapi/v1.0/account/~/extension/~/presence",
                "/restapi/v1.0/account/~/extension/~/message-store"
            ])
        
        subscription.register()
            {
                (apiresponse,apiexception) in
                print("Subscribing",apiresponse!.JSONStringify(apiresponse!.getDict(), prettyPrinted: true))
                print("Subscribing",apiresponse!.getResponse())
        }
        
        
//        platform.post("/account/~/extension/~/ringout", body :
//            [ "to": ["phoneNumber": "18315941779"],
//                "from": ["phoneNumber": "15856234190"],
//                "callerId": ["phoneNumber": ""],
//                "playPrompt": "true"
//            ])
//            {
//                (apiresponse,apiexception) in
//                print(apiresponse!.JSONStringify(apiresponse!.getDict(), prettyPrinted: true))
//        }
        
        platform.post("/account/~/extension/~/sms", body :
            [ "to": [["phoneNumber": "17752204114"]],
                "from": ["phoneNumber": "15856234190"],
                "text": "Test"
            ])
            {
                (apiresponse,apiexception) in
                print(apiresponse!.JSONStringify(apiresponse!.getDict(), prettyPrinted: true))
        }
        
        print("completed ring-out")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

