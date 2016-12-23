//
//  RiderLocationViewController.swift
//  CUBER
//
//  Created by uics13 on 11/17/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import MapKit

class RiderLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var requestLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var requestUsername = ""
    
    var desCLLocation = CLLocation(latitude: 0, longitude: 0)
    
    var driCLLocation = CLLocation(latitude: 0, longitude: 0)
    
    //var DriverRiderDistance = 0.0
    
    var locationManager = CLLocationManager()
    
    var accept = false
    
    var pickedup = false
    
    var canceled = false
    
    @IBOutlet weak var cancelDriveButton: UIButton!

    
    @IBOutlet weak var acceptRequestButton: UIButton!
    @IBOutlet weak var PickedUpRider: UIButton!
    @IBOutlet var riderDestinationLabel: UILabel!
    @IBOutlet var destinationDistanceLabel: UILabel!
    @IBOutlet var map: MKMapView!
    
    func displayAlert(title: String, message: String) {
        
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertcontroller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertcontroller, animated: true, completion: nil)
        
    }
    
    @IBAction func acceptRequest(_ sender: AnyObject) {
        
        if pickedup == false{
            
            if canceled == false{
        
        accept = true
        
        cancelDriveButton.setTitle("Cancel Drive", for: [])
        
        //find the request on parse
        let query = PFQuery(className: "RiderRequest")
        
        acceptRequestButton.setTitle("On the way to the rider's location", for: [])
        
        PickedUpRider.setTitle("Picked up?", for: [])
        
        query.whereKey("username", equalTo: requestUsername)
        
        query.findObjectsInBackground { (objects, error) in
            
            if let riderRequests = objects {
                
                for riderRequest in riderRequests {
                    
                    //notifying this request has been accepted
                    riderRequest["driverResponded"] = PFUser.current()?.username
                    
                    riderRequest.saveInBackground()
                    
                    //to find directions to user location
                    let requestCLLocation = CLLocation(latitude: self.requestLocation.latitude, longitude: self.requestLocation.longitude)
                    
                    //apple maps
                    CLGeocoder().reverseGeocodeLocation(requestCLLocation, completionHandler: { (placemarks, error) in
                        
                        if let placemarks = placemarks {
                            
                            if placemarks.count > 0 {
                                
                                let mKPlacemark = MKPlacemark(placemark: placemarks[0])
                                
                                let mapItem = MKMapItem(placemark: mKPlacemark)
                                
                                mapItem.name = self.requestUsername
                                
                                let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                                
                                mapItem.openInMaps(launchOptions: launchOptions)
                                
                            }
                            
                        }
                        
                        
                    })
                    
                }
                
            }
            
            
        }
        }
        }
        
        
        
    }
    
    
    //End rider button, save the endride driver name in to the server(riderRequest class)
    @IBAction func CancelDrive(_ sender: UIButton) {
        if self.accept == true {
            
            //if self.pickedup == false{
            canceled = true
            PickedUpRider.setTitle("", for: [])
            acceptRequestButton.setTitle("", for: [])
            
            let rquery = PFQuery(className: "RiderRequest")
            rquery.whereKey("username", equalTo: requestUsername)
            
            rquery.findObjectsInBackground { (objects, error) in
                
                if let riderRequests = objects {
                    
                    for riderRequest in riderRequests {
                        
                        //notifying this request has been accepted
                        riderRequest["DriverCanceled"] = PFUser.current()?.username
                        
                        riderRequest.saveInBackground()
                    }
                }
            }
            if self.pickedup == false{
                displayAlert(title: "You Have Canceled the Drive", message: "You can go back to request list to accept other request")
            
            }else{
                displayAlert(title: "Have Arrived Rider's Destination, Ended Drive", message: "You can go back to request list to accept other request")
            }
        }

    }
    
    
    
    //End rider button, save the endride driver name in to the server(riderRequest class)
    
    

     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
     if let location = manager.location?.coordinate {
    
        let driverLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
     
        driCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
        
        //self.map.removeAnnotations(self.map.annotations)
        
        let latDelta = abs(driverLocation.latitude - requestLocation.latitude) * 2 + 0.005
        
        let lonDelta = abs(driverLocation.longitude - requestLocation.longitude) * 2 + 0.005
        
        let region = MKCoordinateRegion(center: driverLocation, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta))
        
        self.map.removeAnnotations(self.map.annotations)
        
        //add driver annotation
        self.map.setRegion(region, animated: true)
        
        let driverAnnotation = MKPointAnnotation()
        
        driverAnnotation.coordinate = CLLocationCoordinate2D(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
        
        driverAnnotation.title = "Your Location"
        
        self.map.addAnnotation(driverAnnotation)
        
        //add rider annotation
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = requestLocation
        
        annotation.title = requestUsername
        
        map.addAnnotation(annotation)
        
        //self.displayAlert(title: "test", message: "testtest")
     
        }
    }
    
    
    @IBAction func HavePickedUp(_ sender: UIButton) {
        
        if self.accept == true{
            if self.canceled == false {
            
            
            
            let ridCLLocation = CLLocation(latitude: self.requestLocation.latitude, longitude: self.requestLocation.longitude)
            
            let distance = ridCLLocation.distance(from: driCLLocation) / 1000
            
            let DriverRiderDistance = round(distance * 100) / 100

            
            if DriverRiderDistance <= 0.1{
            self.acceptRequestButton.setTitle("", for: [])
            PickedUpRider.setTitle("One the way to the rider's Destination", for: [])
            cancelDriveButton.setTitle("End Drive", for: [])
                
            pickedup = true
            
            CLGeocoder().reverseGeocodeLocation(self.desCLLocation, completionHandler: { (placemarks, error) in
                
                if let placemarks = placemarks {
                    
                    if placemarks.count > 0 {
                        
                        let mKPlacemark = MKPlacemark(placemark: placemarks[0])
                        
                        let mapItem = MKMapItem(placemark: mKPlacemark)
                        
                        mapItem.name = "\(self.requestUsername)'s Destination"
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        
                        mapItem.openInMaps(launchOptions: launchOptions)
                        
                    }
                }
                
            })
            }else{
             self.displayAlert(title: "You are too far from your rider", message: "Please arrive to rider's location first")
            }
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.map.layer.borderWidth = 4
        self.map.layer.borderColor = UIColor.white.cgColor
        
        print("User Location")
        print(requestLocation)
        
        //get the coordinates of rider's destination from DestinationLocation class in server
        let DesQuery = PFQuery(className: "DestinationLocation")
        
        DesQuery.whereKey("username", equalTo: requestUsername)
        
        DesQuery.findObjectsInBackground { (objects, error) in
            
            if let Destinations = objects {
                
                for Destination in Destinations {
                    
                    if let desLocation = Destination["DestinationLocation"] as? PFGeoPoint {
                        
                        // get the coordinate of rider's destination
                        self.desCLLocation = CLLocation(latitude: desLocation.latitude, longitude: desLocation.longitude)
                        
                        //get the coordinate of rider's location
                        
                        
                        
                        let riderCLLocation = CLLocation(latitude: self.requestLocation.latitude, longitude: self.requestLocation.longitude)
                        
                        //self.displayAlert(title: "\(riderCLLocation)", message: "test")
                        
                        //get the distance between rider's and his destination
                        let distance = riderCLLocation.distance(from: self.desCLLocation) / 1000
                        
                        //get the round distance
                        let roundedDistance = round(distance * 100) / 100
                        
                        //show the distance on the label
                        self.destinationDistanceLabel.text = "About \(roundedDistance)Km"
                        
                        Destination.saveInBackground()
                    }
                }
            }
        }
        
        
        
        
        // get the rider's destination from the RiderRequest class in server
        let query = PFQuery(className: "RiderRequest")
        
        query.whereKey("username", equalTo: requestUsername)
        
        query.findObjectsInBackground { (objects, error) in
            
            if let riderRequests = objects {
                
                for riderRequest in riderRequests {
                    
                    //the destination label will show the rider's destination
                    self.riderDestinationLabel.text = "\(riderRequest["RiderDestination"] as! String)"
                    
                    riderRequest.saveInBackground()
                }
            }
        }
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
