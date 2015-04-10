//
//  ViewController.swift
//  OnTheMap
//
//  Created by Denys Medina Aguilar on 29/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    internal var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure activity message
        
        hud = MBProgressHUD(view: view)
        hud.color = UIColor.orangeColor()
        hud.minSize = CGSizeMake(135.0, 135.0)
        view.addSubview(hud)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Clear error message
        self.errorMessageLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: -  Authentications Credentials
    
    @IBAction func loginButtonTouch(sender: UIButton) {
        
        // Hide keyboard if presented
        
        view.endEditing(true)
        
        // Validate email and password
        
        if countElements(usernameTextField.text) == 0 {
            
            errorMessageLabel.text = "Email is empty"
        }
        else if countElements(passwordTextField.text) == 0 {
            
            errorMessageLabel.text = "Password is empty"
        }
        else {
            
            hud.labelText = "Validating"
            hud.show(true)
            
            // Call autentication service
            
            UdacityClient.sharedInstance().authenticateWithUserAndPwd(usernameTextField.text, password: passwordTextField.text) { success, error in
                
                // Show error message to user
                
                if let error = error {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.hud.hide(true)
                        self.errorMessageLabel.text = error
                    }
                }
                else if success {
                    
                    // Complete authentication with this commun method
                    self.completeAuthentication()
                }
            }
        }
    }
    
    // MARK: - Authentication With Facebook
    
    @IBAction func autenticateWithFacebook(sender: UIButton) {
        
        // Initialize login manager
        let login = FBSDKLoginManager()
        
        // Perform login with Facebook
        login.logInWithReadPermissions(["email"]) { result, error in
            
            // If error, display it to user in label
            if let error = error {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.errorMessageLabel.text = "Error authenticating with Facebook"
                }
                
            }
            
            // If process was cancell show a message in label
            else if result.isCancelled {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.errorMessageLabel.text = "Facebook authentication cancelled"
                }
                
            }
            else {
                
                self.hud.labelText = "Creating Session"
                self.hud.show(true)
                
                // When authentication was sucessfull, create a Udacity session
                
                println(FBSDKAccessToken.currentAccessToken().tokenString)
                UdacityClient.sharedInstance().authenticateWithToken( FBSDKAccessToken.currentAccessToken().tokenString ) { success, error in
                    
                    // Show error to user
                    if let error = error {
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            self.hud.hide(true)
                            self.errorMessageLabel.text = error
                        }
                    }
                    else if success {
                        
                        // Call this commun method to complete authentication
                        self.completeAuthentication()
                    }
                }
            }
        }
    }
    
    // MARK: -  Sign Up Udacity
    
    @IBAction func openSignUpWeb(sender: UIButton) {
        
        // Open Sign Up Udacity URL
        if let url = NSURL(string: UdacityClient.Constants.SignUpURL) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func completeAuthentication() {
        
        
        // Update activity message text
        hud.labelText = "Getting user information"
        
        // Call Get Public User Data from Udacity
        UdacityClient.sharedInstance().getUserPublicData() { success, error in
        
            // If there is an error getting user info, app will continue with the flow but user won't be able to post his data to the server, only will see other students info
            // Print error, it wil be presented to the user in next view controller
            if !success {
                
                println("Error Account Info. \(error)")
            }
                
            dispatch_async(dispatch_get_main_queue()) {
                
                // Instantiate map view controller and present it to the user
                
                self.hud.hide(true)
                
                if let studentLocationTabVC = self.storyboard?.instantiateViewControllerWithIdentifier("studentsLocation") as? UIViewController {
                    
                    self.presentViewController(studentLocationTabVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: -  TextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == usernameTextField {
            
            passwordTextField.becomeFirstResponder()
        }
        else {
            
            passwordTextField.resignFirstResponder()
        }
        
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}

