//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Denys Medina Aguilar on 30/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//

import Foundation

class ParseClient: Client {

    // Student location array variable
    var studentsLocation = [StudentLocation]()
    
    // Returns a single instance of this client
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient(baseUrlString : Constants.baseURL)
        }
        
        return Singleton.sharedInstance
    }
    
    // MARK: - Get Students Location
    
    func getStudentsLocation(completionHandler : (success: Bool, errorString: String?) -> Void ) {
        
        // Create headers and body parameters
        
        let headers = [
            ParameterKeys.AppID : Constants.applicationID,
            ParameterKeys.ApiKey: Constants.apiKey]
        
        let parameters = [ParameterKeys.ResultsLimit : Constants.resultsLimit]
        
        // Call to generic GET Method specifying method's name and url parameters
        
        taskForGETMethod(Methods.StudentLocationList, parameters: parameters, headers: headers) {
            
            JSONResult , error in
            
             // If there is an error it returns an error description to the view controller
            
            if let error = error {
                
                completionHandler(success: false, errorString: error.localizedDescription)
                println("Error \(error.debugDescription)")
                
            }
            else {
                
                // Get results array returned by Udacity and assign to studentsLocation global variable
                
                if let results = JSONResult["results"] as? [[String: AnyObject]] {
                    
                    self.studentsLocation = StudentLocation.locationsFromResults(results)
                    completionHandler(success: true , errorString: nil)
                    
                }
                else {
                    
                    // Returns an error if results was not found in the JSON response
                    
                    completionHandler(success: false , errorString: "Error getting locations. Results not found")
                }
            }
        }
    }
    
    // MARK: - Post Student Location
    
    func postStudentLocation(studentLocation: StudentLocation, completionHandler: (sucess: Bool, errorString: String? ) -> Void) {
        
        // Create headers and body parameters
        
        let headers = [
            ParameterKeys.AppID : Constants.applicationID,
            ParameterKeys.ApiKey: Constants.apiKey]
        
        // Call to generic POST Method specifying method's name, without url parameters and with body parameters
        
        taskForPOSTMethod(Methods.AddStudentLocation, parameters: nil, headers: headers, jsonBody: studentLocation.getDictionaryRepresentation()) {
            
            JSONResult, error in
            
            // If there is an error it returns an error description to the view controller
            if let error = error {
                
                completionHandler(sucess: false, errorString:error.localizedDescription)
        
            }
            else {
                
                // Check for objectID returned by Udacity
                
                if let objectID = JSONResult[JSONResponseKeys.studentID] as? String {
                    
                    println("objectID = \(objectID)")
                    completionHandler(sucess: true, errorString: nil)
                    
                }
                else {
                    
                    // Returns an error if results was not found in the JSON response
                    
                    completionHandler(sucess: false, errorString: "Error posting location. ObjectID not found")
                }
            }
        }
    }
    
    // MARK: - Authentication with credentials
    
    func updateStudentLocation(studentLocation: StudentLocation, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        // Create headers and body parameters
        
        let headers = [
            ParameterKeys.AppID : Constants.applicationID,
            ParameterKeys.ApiKey: Constants.apiKey]
        
        // Replace objectID key in the url
        
        if let method = ParseClient.subtituteKeyInMethod(Methods.UpdateStudentLocation, key: URLKeys.ObjectID, value: studentLocation.objectID) {
            
            // Call to generic PUT Method specifying method's name, without url parameters and with body parameters
            
            taskForPUTMethod(method, parameters: nil, headers: headers, jsonBody: studentLocation.getDictionaryRepresentation()) {
                
                JSONResult, error in
                
                // Return error description to view Controller
                if let error = error {
                    
                    completionHandler(success: false, errorString: error.localizedDescription)
                    
                }
                else {
                    
                    // Check for field updatedAt to verify the update was successful
                    
                    if let date = JSONResult[JSONResponseKeys.dateUpdate] as? NSString {
                        
                        println("date = \(date)")
                        completionHandler(success: true, errorString: nil)
                        
                    }
                    else {
                        
                        // Return an error if the date was not found
                        completionHandler(success: false, errorString: "Error updating location, expected response not found")
                    }
                }
            }
        }
    }
    
    // MARK: - Search Students Query
    
    func searchForStudentsLocationByName(firstName: String, lastName: String, completionHandler: (results: [StudentLocation]? , errorString: String?) -> Void) {
        
        // Create headers and compound query by firstName and lastName
        
        let headers = [
            ParameterKeys.AppID : Constants.applicationID,
            ParameterKeys.ApiKey: Constants.apiKey]
        
        let query = "{\"$or\":[{\"firstName\":\"\(firstName)\"},{\"lastName\":\"\(lastName)\"}]}".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        // Set query parameter
        let parameters = ["where":query]
        
        // Call to generic GET Method specifying method's name and url parameters
        
        taskForGETMethod(Methods.SearchStudentLocation, parameters: parameters, headers: headers) {
            
            JSONResult , error in
            
            // Return error description to View Controller
            if let error = error {
                
                completionHandler(results: nil, errorString: error.localizedDescription)
                println("Error \(error.description)")
                
            }
            else {
                
                // Check and return for an array of results in the response
                
                if let results = JSONResult["results"] as? [[String: AnyObject]] {
                    
                    completionHandler(results: StudentLocation.locationsFromResults(results) , errorString: nil)
                    
                }
                else {
                    
                    // If there weren't results, return an error
                    completionHandler(results: nil, errorString: "Error posting location. ObjectID not found")
                }
            }
        }
    }
    
    // MARK: - Get Current User Location
    
    func getCurrentUserLocation() -> StudentLocation? {
        
        // Look for the current user location in the global studentsLocation variable
        
        let results: [StudentLocation] = studentsLocation.filter() { (student: StudentLocation) -> Bool in
            return student.uniqueKey == UdacityClient.sharedInstance().user?.userID }
        
        // Return only the first post or register if user has more than one
        if !results.isEmpty {
            
            return results[0]
        }
        
        return nil
        
    }
    
    // MARK: - Error with Data
    
    override func errorForData(data: NSData?, httpStatus: Int) -> NSError {
        
        var clientError = super.errorForData(data, httpStatus: httpStatus)
        
        // If response contains data, get Parse error message and code
        
        if let data = data {
            
            parseJSONWithCompletionHandler(data) { parsedResult, error in
                
                println(parsedResult)
                
                if let errorMessage = parsedResult[JSONResponseKeys.ErrorMessage] as? String {
                    if let code = parsedResult[JSONResponseKeys.Status] as? Int {
                        let userInfo = [NSLocalizedDescriptionKey : errorMessage]
                        clientError =  NSError(domain: "Parse Error", code: code, userInfo: userInfo)
                    }
                }
            }
        }
        
        return clientError
        
    }
    
}
