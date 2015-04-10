//
//  TabViewController.swift
//  OnTheMap
//
//  Created by Denys Medina Aguilar on 09/04/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//  Class Use as base of Tabbed View Controllers. 
//  This class encapsule common behaviour of all tabs

import UIKit

class TabViewController: UIViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var postLocationButton: UIBarButtonItem!
    internal var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure activity view message
        
        hud = MBProgressHUD(view: view)
        hud.color = UIColor.orangeColor()
        hud.minSize = CGSizeMake(135.0, 135.0)
        view.addSubview(hud)
        
        // If user names are empty, it disable post location functionality
        if let user = UdacityClient.sharedInstance().user {
            
            if user.lastName.isEmpty {
                
                postLocationButton.enabled = false
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        loadStudentsLocation()
        
    }

    // MARK: - Get Students Location - To be implemented by each tab
    func loadStudentsLocation() {
        
    }
    
    // MARK: - Refresh Student Location
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        
        loadStudentsLocation()
    }
    
    // MARK: - Posts Students Location
    
    @IBAction func postStudentInfo(sender: UIBarButtonItem) {
        
        // Check if current user posted his location previously and show a message
        if let location = ParseClient.sharedInstance().getCurrentUserLocation() {
            
            let message = UIAlertView(title: "Student Location", message: "You have already posted a Student Location. Would you like to overwrite your current location?", delegate: self, cancelButtonTitle: "Overwrite", otherButtonTitles: "Cancel")
            
            message.show()
        }
    
        else {
            // Show modal location view controller
            performSegueWithIdentifier("postStudentLocation", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            
            if identifier == "postStudentLocation" {
                
                // Set studentLocation variable if user posted information previously
                let locationVC = segue.destinationViewController as LocationViewController
                locationVC.studentLocation = ParseClient.sharedInstance().getCurrentUserLocation()
            }
        }
    }
    
    // MARK: - AlerView Delegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        // If user select override location, then show location view controller modally
        if buttonIndex == alertView.cancelButtonIndex {
            
            performSegueWithIdentifier("postStudentLocation", sender: nil)
        }
        
    }

}
