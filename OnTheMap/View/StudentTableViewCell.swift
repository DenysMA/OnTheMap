//
//  StudentTableViewCell.swift
//  OnTheMap
//
//  Created by Denys Medina Aguilar on 09/04/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//  Custom UITableViewCell to show student name, shared URL and location, used in SearchViewController

import UIKit

class StudentTableViewCell: UITableViewCell {

    @IBOutlet weak var studentNameLabel: UILabel! //Student full name
    @IBOutlet weak var mediaLabel: UILabel! // Shared URL
    @IBOutlet weak var locationLabel: UILabel! //Student Location String (mapString)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
