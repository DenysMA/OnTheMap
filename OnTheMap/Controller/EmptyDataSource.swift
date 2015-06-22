//
//  EmptyDataSource.swift
//  OnTheMap
//
//  Created by Denys Medina Aguilar on 09/04/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//  Data Source Class use with Table Views to display a Cell of No Results

import Foundation
import UIKit

class EmptyDataSource: NSObject, UITableViewDataSource {

    
    // MARK: - Empty Data Source Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // default row
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // return empty cell configured in table view in the story board
        return tableView.dequeueReusableCellWithIdentifier("emptyCell", forIndexPath: indexPath) as! UITableViewCell
        
    }
    
    
}
