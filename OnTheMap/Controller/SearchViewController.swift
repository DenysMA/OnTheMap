//
//  SearchViewController.swift
//  OnTheMap
//
//  Created by Denys Medina Aguilar on 09/04/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: TabViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    private var searchResults = [StudentLocation]()
    private let emptyDS = EmptyDataSource()
    
    // Validate search results and switch datasource when there is no results
    func updateCurrentDataSource() {
        
        if searchResults.isEmpty {
            tableView.dataSource = emptyDS
        }
        else {
            tableView.dataSource = self
        }
    }
    
    // MARK: - Search Students Location
    
    @IBAction func search(sender: UIButton) {
        
        // dismiss keyboard
        view.endEditing(true)
        
        //  Validate name text field
        if !nameTextField.text.isEmpty {
            
            var firstName = nameTextField.text
            var lastName = nameTextField.text
            
            let names = nameTextField.text.componentsSeparatedByString(" ")
            
            // Split name into first and last name
            
            if names.count == 2 {
                
                firstName = names[0]
                lastName = names[1]
            }
         
            hud.labelText = "Searching"
            hud.show(true)
            
            // Call search query Parse service
            
            ParseClient.sharedInstance().searchForStudentsLocationByName(firstName.capitalizedString, lastName: lastName.capitalizedString) {
                results, error in
                
                // Show error to the user
                if let error = error {
        
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.hud.hide(true)
                        Message.showErrorMessage("Search error", error: error)
                    }
                    println(error)
                    
                }
                else {
                    
                    // If results, check for location textfield and filter location if needed
                    if let results = results {
                        
                        if !self.locationTextField.text.isEmpty {
                            self.searchResults = self.filterLocation(self.locationTextField.text, resultSet: results)
                        }
                        else {
                            self.searchResults = results
                        }
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            // Reload table info
                            
                            self.hud.hide(true)
                            self.updateCurrentDataSource()
                            self.tableView.reloadData()
                        }
                        
                    }
                }
            }
        }
        else if !locationTextField.text.isEmpty {

            hud.labelText = "Searching"
            hud.show(true)
            
            // Filter results for location, if name field is empty, use Parse shared students location array to perform the search
            searchResults = filterLocation(locationTextField.text, resultSet: ParseClient.sharedInstance().studentsLocation)
            
            hud.hide(true)
            updateCurrentDataSource()
            tableView.reloadData()
            
        }
        else {
            
            // If both fiels are empty, clean results and table
            searchResults.removeAll(keepCapacity: false)
            updateCurrentDataSource()
            tableView.reloadData()
            
        }
    }
    
    // MARK: - Table View DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResults.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Configure cell View
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell", forIndexPath: indexPath) as! StudentTableViewCell
        let studentLocation = searchResults[indexPath.row]
        
        // Set student values in labels
        cell.studentNameLabel.text = studentLocation.firstName + " " + studentLocation.lastName
        cell.mediaLabel.text = studentLocation.mediaURL
        cell.locationLabel.text = studentLocation.mapString
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // If a cell is selected open up the student URL 
        
        let studentLocation = searchResults[indexPath.row]
        if let url = NSURL(string: studentLocation.mediaURL) {
            
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func filterLocation(location: String, resultSet: [StudentLocation]) -> [StudentLocation] {
        
        // Filter resultSet by location string
        
        let results = resultSet.filter() { (student: StudentLocation) -> Bool in
            if let range = student.mapString.lowercaseString.rangeOfString(location.lowercaseString, options: NSStringCompareOptions.CaseInsensitiveSearch) {
                return true
            }
            return false
        }
        
        return results
    }
    
    // MARK: - TextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
}
