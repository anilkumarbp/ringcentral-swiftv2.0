//
//  Platform.swift
//  src
//
//  Created by Anil Kumar BP on 1/21/16.
//  Copyright © 2016 Anil Kumar BP. All rights reserved.
//


import Foundation

/// Platform used to call HTTP request methods.
public class Platform {
    
    // platform Constants
    public let ACCESS_TOKEN_TTL = "3600"; // 60 minutes
    public let REFRESH_TOKEN_TTL = "604800"; // 1 week
    public let TOKEN_ENDPOINT = "/restapi/oauth/token";
    public let REVOKE_ENDPOINT = "/restapi/oauth/revoke";
    public let API_VERSION = "v1.0";
    public let URL_PREFIX = "/restapi";
    
    
    
    // Platform credentials
    internal var auth: Auth
    internal var client: Client
    internal let server: String
    internal let appKey: String
    internal let appSecret: String
    internal var appName: String
    internal var appVersion: String
    internal var USER_AGENT: String
    
    
    /// Constructor for the platform of the SDK
    ///
    /// - parameter appKey:      The appKey of your app
    /// - parameter appSecet:    The appSecret of your app
    /// - parameter server:      Choice of PRODUCTION or SANDBOX
    public init(client: Client, appKey: String, appSecret: String, server: String, appName: String = "", appVersion: String = "") {
        self.appKey = appKey
        self.appName = appName != "" ? appName : "Unnamed"
        self.appVersion = appVersion != "" ? appVersion : "0.0.0"
        self.appSecret = appSecret
        self.server = server
        self.auth = Auth()
        self.client = client
        self.USER_AGENT = "Swift :" + "/App Name : " + appName + "/App Version :" + appVersion + "/Current iOS Version :" + "/RCSwiftSDK";
        
    }
    
    
    // Returns the auth object
    ///
    public func returnAuth() -> Auth {
        return self.auth
    }
    
    /// func createUrl
    ///
    /// @param: path              The username of the RingCentral account
    /// @param: options           The password of the RingCentral account
    /// @response: ApiResponse    The password of the RingCentral account
    public func createUrl(path: String, options: [String: AnyObject]) -> String {
        var builtUrl = ""
        if(options["skipAuthCheck"] === true){
            builtUrl = builtUrl + self.server + path
            return builtUrl
        }
        builtUrl = builtUrl + self.server + self.URL_PREFIX + "/" + self.API_VERSION + path
        return builtUrl
    }
    
    /// Authenticates the user with the correct credentials
    ///
    /// - parameter username:    The username of the RingCentral account
    /// - parameter password:    The password of the RingCentral account
    public func login(username: String, ext: String, password: String, completion: (apiresponse: ApiResponse?,apiexception: NSException?) -> Void) {
        requestToken(self.TOKEN_ENDPOINT,body: [
            "grant_type": "password",
            "username": username,
            "extension": ext,
            "password": password,
            "access_token_ttl": self.ACCESS_TOKEN_TTL,
            "refresh_token_ttl": self.REFRESH_TOKEN_TTL
            ]) {
                (t,e) in
                self.auth.setData(t!.getDict())
                completion(apiresponse: t, apiexception: e)
        }
    }
    
    
    /// Refreshes the Auth object so that the accessToken and refreshToken are updated.
    ///
    /// **Caution**: Refreshing an accessToken will deplete it's current time, and will
    /// not be appended to following accessToken.
    public func refresh(completion: (apiresponse: ApiResponse?,apiexception: NSException?) -> Void)  {
        if(!self.auth.refreshTokenValid()){
            NSException(name: "Refresh token has expired", reason: "reason", userInfo: nil).raise()
        }
        requestToken(self.TOKEN_ENDPOINT,body: [
            
            "refresh_token": self.auth.refreshToken(),
            "grant_type": "refresh_token",
            "access_token_ttl": self.ACCESS_TOKEN_TTL,
            "refresh_token_ttl": self.REFRESH_TOKEN_TTL
            ]) {
                (t,e) in
                self.auth.setData(t!.getDict())
                completion(apiresponse: t, apiexception: e)
        }
    }
    
    /// func inflateRequest ()
    ///
    /// @param: request                 NSMutableURLRequest
    /// @param: options                 list of options
    /// @response: NSMutableURLRequest
    public func inflateRequest(request: NSMutableURLRequest, options: [String: AnyObject], completion: (apiresponse: ApiResponse?,apiexception: NSException?) -> Void) -> NSMutableURLRequest {
        if options["skipAuthCheck"] == nil {
            ensureAuthentication() {
                (t,e) in
                completion(apiresponse: t, apiexception: e)
            }
            let authHeader = self.auth.tokenType() + " " + self.auth.accessToken()
            request.setValue(authHeader, forHTTPHeaderField: "Authorization")
            request.setValue(self.USER_AGENT, forHTTPHeaderField: "User-Agent")
        }
        return request
    }
    
    
    
    
    /// func sendRequest ()
    ///
    /// @param: request             NSMutableURLRequest
    /// @param: options             list of options
    /// @response: ApiResponse      Callback
    public func sendRequest(request: NSMutableURLRequest, options: [String: AnyObject]!, completion: (apiresponse: ApiResponse?,apiexception: NSException?) -> Void) {
        client.send(inflateRequest(request, options: options){
            (t,e) in
            completion(apiresponse: t, apiexception: e)
            }) {
                (t,e) in
                completion(apiresponse: t, apiexception: e)
        }
    }
    
    
    ///  func requestToken ()
    ///
    /// @param: path    The token endpoint
    /// @param: array   The body
    /// @return ApiResponse
    func requestToken(path: String, body: [String:AnyObject], completion: (apiresponse: ApiResponse?,exception: NSException?) -> Void) {
        let authHeader = "Basic" + " " + self.apiKey()
        var headers: [String: String] = [:]
        headers["Authorization"] = authHeader
        headers["Content-type"] = "application/x-www-form-urlencoded;charset=UTF-8"
        headers["User-Agent"] = self.USER_AGENT
        var options: [String: AnyObject] = [:]
        options["skipAuthCheck"] = true
        let urlCreated = createUrl(path,options: options)
        sendRequest(self.client.createRequest("POST", url: urlCreated, query: nil, body: body, headers: headers), options: options){
            (r,e) in
            completion(apiresponse: r,exception: e)
        }
    }
    
    
    
    /// Base 64 encoding
    func apiKey() -> String {
        let plainData = (self.appKey + ":" + self.appSecret as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        return base64String
    }
    
    
    
    /// Logs the user out of the current account.
    ///
    /// Kills the current accessToken and refreshToken.
    public func logout(completion: (apiresponse: ApiResponse?,apiexception: NSException?) -> Void) {
        requestToken(self.TOKEN_ENDPOINT,body: [
            "token": self.auth.accessToken()
            ]) {
                (t,e) in
                self.auth.reset()
                completion(apiresponse: t, apiexception: e)
        }
    }
    
    
    /// Check if the accessToken is valid
    func ensureAuthentication(completion: (apiresponse: ApiResponse?,exception: NSException?) -> Void) {
        if (!self.auth.accessTokenValid()) {
            refresh() {
                (r,e) in
                completion(apiresponse: r,exception: e)
            }
        }
    }
    
    
    //  Generic Method calls  ( HTTP ) GET
    ///
    /// @param: url             token endpoint
    /// @param: query           body
    /// @return ApiResponse     Callback
    public func get(url: String, query: [String: String]?=["":""], body: [String: AnyObject]?=nil, headers: [String: String]?=["":""], options: [String: AnyObject]?=["":""], completion: (apiresponse: ApiResponse?,exception: NSException?) -> Void) {
        
        let urlCreated = createUrl(url,options: options!)
        sendRequest(self.client.createRequest("GET", url: urlCreated, query: query, body: body, headers: headers!), options: options) {
            (r,e) in
            completion(apiresponse: r,exception: e)
        }
    }
    
    
    // Generic Method calls  ( HTTP ) POST
    ///
    /// @param: url             token endpoint
    /// @param: body            body
    /// @return ApiResponse     Callback
    public func post(url: String, query: [String: String]?=["":""], body: [String: AnyObject] = ["":""], headers: [String: String]?=["":""], options: [String: AnyObject]?=["":""], completion: (apiresponse: ApiResponse?,exception: NSException?) -> Void) {
        
        let urlCreated = createUrl(url,options: options!)
        sendRequest(self.client.createRequest("POST", url: urlCreated, query: query, body: body, headers: headers!), options: options) {
            (r,e) in
            completion(apiresponse: r,exception: e)
        }
    }
    
    // Generic Method calls  ( HTTP ) PUT
    ///
    /// @param: url             token endpoint
    /// @param: body            body
    /// @return ApiResponse     Callback
    public func put(url: String, query: [String: String]?=["":""], body: [String: AnyObject] = ["":""], headers: [String: String]?=["":""], options: [String: AnyObject]?=["":""], completion: (apiresponse: ApiResponse?,exception: NSException?) -> Void) {
        
        let urlCreated = createUrl(url,options: options!)
        sendRequest(self.client.createRequest("PUT", url: urlCreated, query: query, body: body, headers: headers!), options: options) {
            (r,e) in
            completion(apiresponse: r,exception: e)
        }
    }
    
    // Generic Method calls ( HTTP ) DELETE
    ///
    /// @param: url             token endpoint
    /// @param: query           body
    /// @return ApiResponse     Callback
    public func delete(url: String, query: [String: String] = ["":""], body: [String: AnyObject]?=nil, headers: [String: String]?=["":""], options: [String: AnyObject]?=["":""], completion: (apiresponse: ApiResponse?,exception: NSException?) -> Void) {
        
        let urlCreated = createUrl(url,options: options!)
        sendRequest(self.client.createRequest("DELETE", url: urlCreated, query: query, body: body, headers: headers!), options: options) {
            (r,e) in
            completion(apiresponse: r,exception: e)
        }
    }
}


