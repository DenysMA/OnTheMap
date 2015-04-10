//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Denys Medina Aguilar on 31/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//

import UIKit

class ListViewController: TabViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Table Data Source Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ParseClient.sharedInstance().studentsLocation.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("studentCell", forIndexPath: indexPath) as UITableViewCell
        let studentLocation = ParseClient.sharedInstance().studentsLocation[indexPath.row]
        
        cell.textLabel?.text = studentLocation.firstName + " " + studentLocation.lastName
        
        return cell
    }
    
    // MARK: - Table Delegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Get student location according to cell selected
        let studentLocation = ParseClient.sharedInstance().studentsLocation[indexPath.row]
        
        println(studentLocation.mediaURL)
        
        if let url = NSURL(string: studentLocation.mediaURL) {
            
            //Open studen URL
            UIApplication.sharedApplication().openURL(url)
        }
        
    }
    
    // MARK: - Get Students Location
    
    override func loadStudentsLocation() {
        
        // Show activity message
        hud.labelText = "Loading"
        hud.show(true)
        
        //Call Parse Client to get a list of students
        
        ParseClient.sharedInstance().getStudentsLocation() { success, error in
            
            // If error, show error message to the user
            if let error = error {
                
                println("Error \(error)")
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.hud.hide(true)
                    Message.showErrorMessage("Students Location", error: error)
                }
            }
            else {
                
                // Reload table to show students Location
                if success {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.hud.hide(true)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
}
