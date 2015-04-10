//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Denys Medina Aguilar on 31/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//  Extension of Parse Client to manage all Constants

import Foundation

extension ParseClient {
    
    // MARK: - Constants
    struct Constants {
        
        // MARK: URLs
        static let baseURL : String = "https://api.parse.com/1/classes/"
        static let applicationID : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let apiKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let resultsLimit = 150
    }
    
    // MARK: - Methods
    struct Methods {
        
        // MARK: Account
        static let StudentLocationList = "StudentLocation"
        static let AddStudentLocation = "StudentLocation"
        static let UpdateStudentLocation = "StudentLocation/{objectid}"
        static let SearchStudentLocation = "StudentLocation"
    }
    
    // MARK: - Parameter Keys
    struct ParameterKeys {
        
        static let AppID = "X-Parse-Application-Id"
        static let ApiKey = "X-Parse-REST-API-Key"
        static let ResultsLimit = "limit"
        static let FirstName = "firstName"
        static let LastName = "lastName"
    }
    
    // MARK: - URL Keys
    struct URLKeys {
        
        static let UserID = "id"
        static let ObjectID = "objectid"
        
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let ErrorMessage = "error"
        static let Status = "code"
        
        // MARK: Authorization
        static let Session = "session"
        static let SessionID = "id"
        
        // MARK: Account
        static let Account = "account"
        static let UserID = "key"
        
        // MARK: Student Data
        static let studentID = "objectId"
        static let dateUpdate = "updatedAt"
        
    }
}