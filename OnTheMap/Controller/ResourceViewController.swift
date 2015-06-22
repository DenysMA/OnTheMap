//
//  ResourceViewController.swift
//  OnTheMap
//
//  Created by Denys Medina Aguilar on 03/04/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//

import UIKit
import MapKit

class ResourceViewController: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mediaTextView: UITextView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!    
    internal var studentLocation: StudentLocation!
    private var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure activity message
        
        hud = MBProgressHUD(view: view)
        hud.color = UIColor.orangeColor()
        hud.minSize = CGSizeMake(135.0, 135.0)
        view.addSubview(hud)
        
        // Configure annotation and ad it to the map
        var point = MKPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude, longitude: studentLocation.longitude)
        mapView.addAnnotation(point)
        
        // Set visible map region
        let region = MKCoordinateRegionMake(point.coordinate, MKCoordinateSpanMake(5, 5))
        mapView.setRegion(region, animated: true)
        
        // Set url in textView if exists
        mediaTextView.text = studentLocation.mediaURL

    }
    
    // MARK: - Tap Gesture Handler
    
    // Manage TextView touches to make it editable or non editable to let the user interact with the URL
    @IBAction func handleTap(sender: UITapGestureRecognizer) {
        
        mediaTextView.becomeFirstResponder()
        mediaTextView.editable = true
    }
    
    // MARK: - Post Students Location
    
    @IBAction func postStudentLocation(sender: UIButton) {
        
        // Validate URL String is well formed
        if !Validation.validateURL(mediaTextView.text) {
            
            // Show validation error
            Message.showErrorMessage("Invalid URL", error: "Please verify your URL (e.g. http(s)://www.udacity.com)")
            return
        }
            
        // Try to create URL from string
        if let url = NSURL(string: mediaTextView.text) {
            studentLocation.mediaURL = url.absoluteString!
        }
        else {
            // Show message if URL was not able to be initialized
            Message.showErrorMessage("Error parsing URL", error: "Error creating URL")
            return
        }
        
        if studentLocation.objectID.isEmpty {
            
            // Create post using Parse Client
            
            hud.labelText = "Posting Location"
            hud.show(true)
            
            // Call post student location service
            ParseClient.sharedInstance().postStudentLocation(studentLocation) { sucess, error in
                
                // Displays error
                if let error = error {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.hud.hide(true)
                        Message.showErrorMessage("Error posting information", error: error)
                        println(error)
                    }
                }
                    
                else {
                    
                    // If post was created, dismiss modal view
                    dispatch_async(dispatch_get_main_queue()) {
                        self.hud.hide(true)
                        Message.showConfirmationMessage("Information posted", view: self.view) {
                            
                            let presentingVC = self.presentingViewController?.presentingViewController
                            presentingVC?.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                }
                
            }
        }
        else {
            
            // Update a new post using Parse Client
            
            hud.labelText = "Updating Location"
            hud.show(true)
            
            // Call update student location service
            ParseClient.sharedInstance().updateStudentLocation(studentLocation) { sucess, error in
                
                // Display error to the user
                if let error = error {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.hud.hide(true)
                        Message.showErrorMessage("Error updating information", error: error)
                        println(error)
                    }
                }
                else {
                    // If success, show confirmation to user and dismiss modal view
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.hud.hide(true)
                        Message.showConfirmationMessage("Information updated", view: self.view) {
                            let presentingVC = self.presentingViewController?.presentingViewController
                            presentingVC?.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                }
            }
        }
    
    }

    // MARK: - Cancel

    @IBAction func Cancel(sender: UIButton) {
        
        // dismiss modal view
        dismissViewControllerAnimated(true, completion: nil)
        
    }


    // MARK: - TextView  Delegate

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            mediaTextView.resignFirstResponder()
            mediaTextView.editable = false
            return false
        }
        
        return true
    }

}
