//
//  User.swift
//  OnTheMap
//
//  Created by Denys Medina Aguilar on 06/04/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//  Struct to keep basic Udacity User Information needed in the app

import Foundation

struct User {
 
    var userID: String = ""     //User identifier
    var firstName: String = ""
    var lastName: String = ""
    
    // Initializer, receives only a unique user identifier
    init(userID: String) {
        
        self.userID = userID
        
    }
    
}