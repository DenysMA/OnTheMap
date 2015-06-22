//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Denys Medina Aguilar on 31/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: TabViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = UdacityClient.sharedInstance().user {
        
            // If user names are empty , show an error to the user
            if user.lastName.isEmpty {
                
                Message.showErrorMessage("Acount Info failed", error: "Error getting user public information")
            }
        }
        
        // Set visible map region
        
        let region = MKCoordinateRegionMake(CLLocationCoordinate2D(latitude: 0, longitude: 0), MKCoordinateSpanMake(150, 360))
        mapView.setRegion(region, animated: true)
        
    }
    
    // MARK: - Get Students Location
    
    override func loadStudentsLocation() {
     
        hud.labelText = "Loading"
        hud.show(true)
        
        // Call get location service
        ParseClient.sharedInstance().getStudentsLocation() { sucess, error in
            
            // If error, display it to the user
            if let error = error {
                
                println("Error \(error)")
                dispatch_async(dispatch_get_main_queue()) {
                 
                    self.hud.hide(true)
                    Message.showErrorMessage("Error getting students location", error: error)
                }
                
            }
            else if sucess {
                
                    // Create annotations and add them to the map
                
                    var annotations = [MKPointAnnotation]()
                    
                    for student in ParseClient.sharedInstance().studentsLocation {
                        
                        var coordinate = CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude)
                        var point = MKPointAnnotation()
                        point.coordinate = coordinate
                        point.title = student.firstName + " " + student.lastName
                        point.subtitle = student.mediaURL
                        annotations.append(point)
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        // Add anotations
                        self.mapView.addAnnotations(annotations)
                        self.hud.hide(true)
                    }
            }
        }

    }
    
    // MARK: - Map Delegate
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        // Configure Anottation
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("annotationView")
        let detailButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
        
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
        }
        
        detailButton.frame = pinView.frame
        pinView.canShowCallout = true
        pinView.rightCalloutAccessoryView = detailButton;
        
        return pinView
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        // When callout Accessory is taped , open up student URL
        
        if let urlString = view.annotation.subtitle {
            
            if let url = NSURL(string: urlString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
}
