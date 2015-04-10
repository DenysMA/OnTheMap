//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Denys Medina Aguilar on 31/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//  Student Location struct use to get information from Parse Client

import Foundation

struct StudentLocation {
    
    // Student Location variables
    
    var objectID:  String = ""
    var uniqueKey: String = ""
    var firstName: String = ""
    var lastName:  String = ""
    var latitude:  Double = 0.0
    var longitude: Double = 0.0
    var mapString: String = ""
    var mediaURL:  String = ""
    var createdAt: NSDate? = nil
    var updatedAt: NSDate? = nil
    
    
    // Initializer that recieves a dictionary
    
    init(dictionary: [String: AnyObject] ) {
        
        if let objectID = dictionary["objectId"] as? String {
            self.objectID = objectID
        }
        if let uniqueKey = dictionary["uniqueKey"] as? String {
            self.uniqueKey = uniqueKey
        }
        if let firstName = dictionary["firstName"] as? String {
            self.firstName = firstName
        }
        if let lastName = dictionary["lastName"] as? String {
            self.lastName = lastName
        }
        if let latitude = dictionary["latitude"] as? Double {
            self.latitude = latitude
        }
        if let longitude = dictionary["longitude"] as? Double {
            self.longitude = longitude
        }
        if let mapString = dictionary["mapString"] as? String {
            self.mapString = mapString
        }
        if let mediaURL = dictionary["mediaURL"] as? String {
            self.mediaURL = mediaURL
        }
        
        // Parsing dates pending
        createdAt = dictionary["createdAt"] as? NSDate
        updatedAt = dictionary["updatedAt"] as? NSDate
        
    }
    
    // Initializer that receives Student Location fields
    init(uniqueKey: String, firstName: String, lastName: String, latitude: Double, longitude: Double, mapString: String, mediaURL: String) {
        
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        
    }
    
    // Return an array of Student Location from an array of dictionary
    static func locationsFromResults(studentsLocation: [[String: AnyObject]]) -> [StudentLocation] {
        
        var students = [StudentLocation]()
        
        for studentLocation in studentsLocation {
            
            students.append( StudentLocation(dictionary: studentLocation) )
            
        }
        
        return students
        
    }
    
    // Return Student Location variables in a dictionary format
    func getDictionaryRepresentation() -> Dictionary<String,AnyObject> {
        
        let studentLocation:[String:AnyObject] = [
            "uniqueKey" : uniqueKey,
            "firstName" : firstName,
            "lastName" : lastName,
            "mapString" : mapString,
            "mediaURL" : mediaURL,
            "latitude" : latitude,
            "longitude" : longitude]
        
        return studentLocation
        
    }
    
    
}