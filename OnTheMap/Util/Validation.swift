//
//  Valitation.swift
//  OnTheMap
//
//  Created by Denys Medina Aguilar on 10/04/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//  Helper class to manage commun validations in the app

import Foundation

class Validation {
    
    //Method to validate if a string is a valid URL using NSPredicate class
    class func validateURL(urlString: String) -> Bool {
        
        let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let urlPredicate = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        return urlPredicate.evaluateWithObject(urlString)
    }
    
}