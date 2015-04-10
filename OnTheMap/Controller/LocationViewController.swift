//
//  LocationViewController.swift
//  OnTheMap
//
//  Created by Denys Medina Aguilar on 03/04/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    internal var studentLocation: StudentLocation?
    private var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure activity message
        
        hud = MBProgressHUD(view: view)
        hud.color = UIColor.orangeColor()
        hud.minSize = CGSizeMake(135.0, 135.0)
        view.addSubview(hud)
        
        // Verify if previous vire controller pass a student object, if not initialize a new one
        
        if studentLocation == nil {
            
            if let user = UdacityClient.sharedInstance().user {
                
                studentLocation = StudentLocation(uniqueKey: user.userID, firstName: user.firstName, lastName: user.lastName, latitude: 0, longitude: 0, mapString: "", mediaURL: "")
            }
        }
        else {
            
            // Set student String location
            locationTextField.text = studentLocation?.mapString
        }
        
    }
    
    // MARK: -  Geocoding
    
    @IBAction func searchLocation(sender: UIButton) {
        
        // Validate location text is not empty
        if !locationTextField.text.isEmpty {
            
            // Initialize GLGeocoder
            let geocoder = CLGeocoder()
            
            hud.labelText = "Searching"
            hud.show(true)
            
            // Geocode address String
            geocoder.geocodeAddressString(locationTextField.text) { (placemarks, error) in
                
                // Show error description
                if error != nil {
                    
                    self.hud.hide(true)
                    Message.showErrorMessage("Error searching your text location", error: error.localizedDescription)
                }
                    
                else {
                    
                    // Hide activity mesage and push next resource view controller passing placemarks results
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.hud.hide(true)
                        self.performSegueWithIdentifier("shareMediaUrl", sender: placemarks)
                        
                    }
                }
            }
        }
        else {
            Message.showErrorMessage("Location Required", error: "Please enter a location.")
        }
    }
    
    // MARK: -  Cancel
    
    @IBAction func Cancel(sender: UIButton) {
        
        // Dismiss modal view
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // MARK: -  Prepare segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            
            if identifier == "shareMediaUrl" {
                
                // Prepare next view controller and set student Location variable
                
                var resourceVC = segue.destinationViewController as ResourceViewController
                
                if let placemarks = sender as? [CLPlacemark] {
                    
                    // Take only first placemark information from the array of placemarks
                    let placemark = placemarks[0]
                    studentLocation?.latitude = placemark.location.coordinate.latitude
                    studentLocation?.longitude = placemark.location.coordinate.longitude
                    studentLocation?.mapString = locationTextField.text
                    resourceVC.studentLocation = studentLocation
                    
                }
            }
        }
    }
    
    // MARK: -  TextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        locationTextField.resignFirstResponder()
    }
    
}
