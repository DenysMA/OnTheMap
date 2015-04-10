//
//  Message.swift
//  OnTheMap
//
//  Created by Denys Medina Aguilar on 08/04/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//  Class to manage common messages in the app, such as errors and confirmations

import Foundation

class Message {
    
    //Show a confirmation message which fades away after 2 seconds, it has a completion handler to perform aditional View Controller behaviour after the message has gone
    class func showConfirmationMessage(message: String, view: UIView, completionHandler:(() -> Void)?) {
        
        let confirmationView = MBProgressHUD(view: view)
        view.addSubview(confirmationView)
        confirmationView.customView = UIImageView(image: UIImage(named: "checkmark"))
        confirmationView.color = UIColor.orangeColor()
        confirmationView.mode = MBProgressHUDMode.CustomView
        confirmationView.labelText = message
        confirmationView.removeFromSuperViewOnHide = true
        confirmationView.userInteractionEnabled = false
        confirmationView.show(true)
        confirmationView.hide(true, afterDelay: 2.0)
        confirmationView.completionBlock = completionHandler
        
    }
    
    //Show a simple alert with the specified title and message error
    class func showErrorMessage(title:String, error: String) {
        
        let errorMessage = UIAlertView(title: title, message: error, delegate: nil, cancelButtonTitle: "OK")
        errorMessage.show()
    }
    
    
}