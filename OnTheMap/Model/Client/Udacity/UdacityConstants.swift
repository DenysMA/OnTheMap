//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Denys Medina Aguilar on 30/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//  Extension to manage all Udacity Client Constants

import Foundation

extension UdacityClient {

    
    // MARK: - Constants
     struct Constants {
        
        // MARK: URLs
        static let baseURL : String = "https://www.udacity.com/api/"
        static let AuthorizationURL : String = "https://www.themoviedb.org/authenticate/"
        static let SignUpURL: String = "https://www.udacity.com/account/auth#!/signup"
    }
    
    // MARK: - Methods
    struct Methods {
        
        // MARK: Account
        static let AuthenticationWithCredentials = "session"
        static let AuthenticationWithToken = "session"
        static let PublicUserData = "users/{id}"
    }
    
    // MARK: - URL Keys
    struct URLKeys {
        
        static let UserID = "id"
        
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let ErrorMessage = "error"
        static let Status = "status"
        
        // MARK: Authorization
        static let Session = "session"
        static let SessionID = "id"
        
        // MARK: Account
        static let Account = "account"
        static let UserID = "key"
        
        
    }
    
}