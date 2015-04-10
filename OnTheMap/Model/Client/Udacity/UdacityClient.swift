//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Denys Medina Aguilar on 30/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//  Udacity Client

import Foundation

class UdacityClient: Client {

    // Udacity session
    var sessionID : String? = nil
    
    // Udacity user information
    var user : User? = nil
    
    // Returns a single instance of this client
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient(baseUrlString : Constants.baseURL)
        }
        
        return Singleton.sharedInstance
    }
    
    // MARK: - Authentication with credentials
    
    func authenticateWithUserAndPwd( username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void ) {
        
        // Create headers and body parameters
        
        let headers = [String : String]()
        let bodyParameters: [String : AnyObject] = ["udacity" : ["username" : username, "password" : password]]
        
        // Call to generic POST Method specifying method's name, without url parameters and with body parameters
        
        self.taskForPOSTMethod(Methods.AuthenticationWithCredentials, parameters: nil, headers: headers, jsonBody: bodyParameters) { JSONResult, error in
            
            // If there is an error it returns an error description to the view controller
            
            if let error = error? {
                
                completionHandler(success: false, errorString: error.localizedDescription)
                println("Error \(error.description)")
                
                
            } else {
                
                // Get sessionID and userID returned by Udacity and assign it to session global variable
                
                if let sessionID = JSONResult.valueForKey(JSONResponseKeys.Session)?.valueForKey(JSONResponseKeys.SessionID) as? String {
                    
                    println("session \(sessionID)")
                    self.sessionID = sessionID
                    
                    if let userID = JSONResult.valueForKey(JSONResponseKeys.Account)?.valueForKey(JSONResponseKeys.UserID) as? String {
                        
                        self.user = User(userID: userID)
                        completionHandler(success: true, errorString: nil)
                        
                    }
                    else {
                        
                        // Returns an error if userId was not found in the JSON response
                        completionHandler(success: false, errorString: "Error user ID not found")
                    }
                }
                else {
                    
                    // Returns an error if sessionId was not found in the JSON response
                    completionHandler(success: false, errorString: "Error session ID not found")
                }
            }
        }
    }
    
    // MARK: - Authentication with Facebook Token
    
    func authenticateWithToken(token: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        // Creates headers and body parameters
        
        let headers = [String : String]()
        let bodyParameters: [String : AnyObject] = ["facebook_mobile" : ["access_token" : token]]
        
        // Call to generic POST Method specifying method's name, without url parameters and with body parameters
        
        self.taskForPOSTMethod(Methods.AuthenticationWithToken, parameters: nil, headers: headers, jsonBody: bodyParameters) { JSONResult, error in
            
            // If there is an error it returns an error description to the view controller
            
            if let error = error? {
                
                var errorMessage = error.description
                
                if let description = error.userInfo?[NSLocalizedDescriptionKey] as? String {
                    errorMessage = description
                }
                
                completionHandler(success: false, errorString: error.localizedDescription)
                println("Error \(error.description)")
                
                
            } else {
                
                // Get sessionID and userID returned by Udacity and assign it to session global variable
                
                if let sessionID = JSONResult.valueForKey(JSONResponseKeys.Session)?.valueForKey(JSONResponseKeys.SessionID) as? String {
                    
                    println("session \(sessionID)")
                    self.sessionID = sessionID
                    
                    if let userID = JSONResult.valueForKey(JSONResponseKeys.Account)?.valueForKey(JSONResponseKeys.UserID) as? String {
                        
                        self.user = User(userID: userID)
                        completionHandler(success: true, errorString: nil)
                        
                    }
                    else {
                        
                        // Returns an error if userId was not found in the JSON response
                        completionHandler(success: false, errorString: "Error user ID not found")
                    }
                }
                else {
                    
                    // Returns an error if sessionId was not found in the JSON response
                    completionHandler(success: false, errorString: "Error session ID not found")
                }
            }
        }
    }
    
    // MARK: - User Public Data
    
    func getUserPublicData(completionHandler: (success: Bool, errorString: String?) -> Void ) {
        
        // Validate if a user has been set previously
        if let userID = user?.userID {
            
            // Replace user ID Key in the method url
            
            if let method = UdacityClient.subtituteKeyInMethod(Methods.PublicUserData, key: URLKeys.UserID, value: userID) {
                
                // Call to generic GET method, sending empty headers and empty parameters
                
                taskForGETMethod(method, parameters: nil, headers: [String:String]()) { JSONResult, error in
                    
                    // If there is an error, it returns a string description
                    
                    if let error = error {
                        
                        completionHandler(success: false, errorString: error.localizedDescription)
                        println(error.description)
                        
                    }
                    
                    else {
                        
                        // Get user first and last name to update those fields in user global variable
                        
                        let JSONResult = JSONResult["user"] as Dictionary<String,AnyObject>
                        
                        if let firstName = JSONResult["first_name"] as? String {
                            self.user?.firstName = firstName
                        }
                        
                        if let lastName = JSONResult["last_name"] as? String {
                            self.user?.lastName = lastName
                        }
                        
                        if let user = self.user {
                            
                            if !user.firstName.isEmpty && !user.lastName.isEmpty {
                                
                                completionHandler(success: true, errorString: nil)
                            }
                            else {
                                
                                // If the user names are not found, it returns an error
                                completionHandler(success: false, errorString: "Error account information not found")
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Parse Udacity JSON
    
    override func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        // Skip the first 5 characters of the response
        
        let data = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError? {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    // MARK: - Error Data
    
    override func errorForData(data: NSData?, httpStatus: Int) -> NSError {
        
        var clientError = super.errorForData(data, httpStatus: httpStatus)
        
        // If there is data, parse result to get Udacity error message
        
        if let data = data {
            
            parseJSONWithCompletionHandler(data) { parsedResult, error in
                
                if let errorMessage = parsedResult[JSONResponseKeys.ErrorMessage] as? String {
                    
                    let userInfo = [NSLocalizedDescriptionKey : errorMessage]
                    clientError =  NSError(domain: "Udacity Error", code: 1, userInfo: userInfo)
                }
            }
        }
        
        return clientError
        
    }
    
}