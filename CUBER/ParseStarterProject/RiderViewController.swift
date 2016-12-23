//
//  RiderViewController.swift
//  CUBER
//
//  Created by uics13 on 10/29/16.
//  Copyright © 2016 Parse. All rights reserved.
//



import UIKit
import Parse
import MapKit
import QuartzCore

class RiderViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    func displayAlert(title: String, message: String) {
        
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertcontroller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertcontroller, animated: true, completion: nil)
        
    }
    
    @IBOutlet var waitTime: UILabel!
    
    @IBOutlet var fare: UILabel!
    

    @IBOutlet var driverDistanceLabel: UILabel!
    
   
    var driverOnTheWay = false
    
    var locationManager = CLLocationManager()
    
    var riderRequestActive = true
    
    var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var coords: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var i: Int = 1
    
    var showDes = false
    
    var canceled = false
    
    @IBOutlet var RiderDestinationText: UITextField!
    @IBOutlet var callAnUberButton: UIButton!
    @IBOutlet var map: MKMapView!
    @IBOutlet weak var ShowDesButton: UIButton!
    
    //show destination button
    @IBAction func ShowDestination(_ sender: UIButton) {
        if driverOnTheWay == false{
        if showDes == false{
            let address = "\(RiderDestinationText.text)"
            
            CLGeocoder().geocodeAddressString(address, completionHandler:{(placemarks, error) in
                
                if error != nil {
                    
                    print("Geocode failed: \(error!.localizedDescription)")
                    self.displayAlert(title: "Sorry we couldn't find the address", message: "Check you destination format(Street Name(or place name), City, State), for example: Old Capitol Mall, Iowa City, Iowa")
                }else{
                    self.showDes = true
                    self.ShowDesButton.setTitle("See Your Location on Map", for: [])
                }
            })
        }else{
            showDes = false
            ShowDesButton.setTitle("See Your Destination on Map", for: [])
        }
    }
    }
    
    
    @IBAction func callAnUber(_ sender: AnyObject) {
        
        
        if riderRequestActive {
            
            callAnUberButton.setTitle("Request a cUber", for: [])
            
            riderRequestActive = false
            
            driverOnTheWay = false
            
            waitTime.text = "Wait Time: "
            driverDistanceLabel.text = ""
            let Reregion = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            map.setRegion(Reregion, animated: true)
            
            
            let query = PFQuery(className: "RiderRequest")
            
            query.whereKey("username", equalTo: (PFUser.current()?.username)!)
            
            query.findObjectsInBackground(block: { (objects, error) in
                
                if let riderRequests = objects {
                    
                    for riderRequest in riderRequests {
                        
                        riderRequest.deleteInBackground()
                        
                    }
                    
                }
                
                
            })
            
            
            let DestinationQuery = PFQuery(className: "DestinationLocation")
            
            DestinationQuery.whereKey("username", equalTo: (PFUser.current()?.username)!)
            
            DestinationQuery.findObjectsInBackground(block: { (objects, error) in
                
                if let riderDestinations = objects {
                    
                    for riderDestination in riderDestinations {
                        
                        riderDestination.deleteInBackground()
                        
                    }
                    
                }
                
                
            })
            
            
            
        } else {
            
            //Check whether the riders have enter the address
            
            if RiderDestinationText.text == ""{
                
                displayAlert(title: "Error in form", message: "Destination address is required")
                
            }
            else {
                
                //check whether the address format is right
                
                let address = "\(RiderDestinationText.text)"
                
                CLGeocoder().geocodeAddressString(address, completionHandler:{(placemarks, error) in
                        
                        if error != nil {
                            
                            print("Geocode failed: \(error!.localizedDescription)")
                            self.displayAlert(title: "Sorry we couldn't find the address", message: "Check you destination format(Street Name(or place name), City, State), for example: Old Capitol Mall, Iowa City, Iowa")
                            
                        }else{
                            
                            if self.userLocation.latitude != 0 && self.userLocation.longitude != 0 {
                                
                                self.riderRequestActive = true
                                
                                self.canceled = false
                                
                                self.driverDistanceLabel.text = ""
                                
                                self.callAnUberButton.setTitle("Cancel cUber", for: [])
                                
                                let riderRequest = PFObject(className: "RiderRequest")
                                
                                riderRequest["username"] = PFUser.current()?.username
                                
                                // add rider destination to the riderRequest class in the server
                                riderRequest["RiderDestination"] = self.RiderDestinationText.text
                                
                                
                                riderRequest["location"] = PFGeoPoint(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude)
                                
                                //riderRequest["Test"] = "A"
                                
                                // add an new class: DestinationLocation, used to save the coordinates of the destinations
                                let DLocation = PFObject(className: "DestinationLocation")
                                
                                DLocation["username"] = PFUser.current()?.username
                                
                                DLocation["DestinationLocation"] = PFGeoPoint(latitude: self.coords.latitude, longitude: self.coords.longitude)
                                //DLocation["Test"] = "B" // used to test
                                
                                //save changes to server
                                DLocation.saveInBackground { (success, error) -> Void in
                                    
                                    
                                    if success {
                                        
                                        print("Rider's Destination has been saved.")
                                        
                                    } else {
                                        
                                        if error != nil {
                                            
                                            print (error)
                                            
                                        } else {
                                            
                                            print ("Error")
                                        }
                                        
                                    }
                                }
                                
                                
                                
                                riderRequest.saveInBackground(block: { (success, error) in
                                    
                                    if success {
                                        
                                        print("Called cuber")
                                        
                                        self.displayAlert(title: "Call Success !!!", message: "Wait for driver accept your request")
                                        
                                        
                                    } else {
                                        
                                        self.callAnUberButton.setTitle("Call An Uber", for: [])
                                        
                                        self.riderRequestActive = false
                                        
                                        self.displayAlert(title: "Could not call cUber", message: "Please try again!")
                                        
                                        
                                    }
                                    
                                    
                                })
                                
                            } else {
                                
                                self.displayAlert(title: "Could not call cUber", message: "Cannot detect your location.")
                                
                            }
                        }
                })
            }
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "logoutSegue" {
            
            locationManager.stopUpdatingLocation()
            
            PFUser.logOut()
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.map.layer.borderWidth = 4
        self.map.layer.borderColor = UIColor.white.cgColor
        
        self.RiderDestinationText.delegate = self
        
        
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        callAnUberButton.isHidden = true
        
        let query = PFQuery(className: "RiderRequest")
        
        query.whereKey("username", equalTo: (PFUser.current()?.username)!)
        
        query.findObjectsInBackground(block: { (objects, error) in
            
            if let objects = objects {
                
                if objects.count > 0 {
                    
                    self.riderRequestActive = true
                    
                    self.callAnUberButton.setTitle("Cancel Uber", for: [])
                    
                }
                
            }
            
            self.callAnUberButton.isHidden = false
            
            
        })
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //get the address
        let address = "\(RiderDestinationText.text)"
        
        // Geocode function, used to transfer the address to the coordinate
        CLGeocoder().geocodeAddressString(address, completionHandler:
            {(placemarks, error) in
                
                if error != nil {
                    print("Geocode failed: \(error!.localizedDescription)")
                    //self.displayAlert(title: "Error in form", message: "Check you destination format")
                } else if placemarks!.count > 0{
                    let placemark = placemarks![0]
                    let location = placemark.location
                    self.coords = location!.coordinate //coordinate of destination
                    //self.displayAlert(title: "\(self.coords)", message: "test coordinate")
                    
                    //let latiDelta = abs(self.coords.latitude - self.userLocation.latitude) * 2 + 0.005
                    
                    //let longDelta = abs(self.coords.longitude - self.userLocation.longitude) * 2 + 0.005
                    
                    

                    
                }
        })
        
        if let location = manager.location?.coordinate {
            
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            if driverOnTheWay == false {
                
                if showDes == false {
                
                let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                
                self.map.setRegion(region, animated: true)
                
                self.map.removeAnnotations(self.map.annotations)
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = userLocation
                
                annotation.title = "Your Location"
                
                self.map.addAnnotation(annotation)
                }else{
                    
                let price1 = 0.25
                    
                let price2 = 0.45
                    
                let price3 = 0.75
                    
                let price4 = 0.93
                    
                let price5 = 1.32
                    
                let riderCLLocation1 = CLLocation(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude)
                    
                let destinationCLLocation1 = CLLocation(latitude: self.coords.latitude, longitude: self.coords.longitude)
                    
                let distance1 = riderCLLocation1.distance(from: destinationCLLocation1) / 1000
                    
                let roundedDistance1 = round(distance1 * 100) / 100
                    
                    print("distance is  ...\(roundedDistance1) for fare calculation")
                    let basefare = 4.00
                    let basefare1 = 5.60
                    let basefare2 = 7.30
                    if (roundedDistance1 < 5)
                    {
                        print ("base fare has reached1")
                        self.fare.text = "Fare Estimate: $\(roundedDistance1*0.3 + basefare) - $\(roundedDistance1*0.3+basefare+price5*0.12+1.67+5)"
                        
                    }else if (roundedDistance1 < 10)
                    { print ("base fare has reached2")
                        self.fare.text = "Fare Estimate: $\(roundedDistance1*0.4 + basefare+1.2) - $\(roundedDistance1*0.4+basefare+price4*0.16+1.2+1.45+5)"
                        
                    }else if (roundedDistance1 <  13)
                    { print ("base fare has reached3")
                        let x = roundedDistance1*0.5+basefare1
                        self.fare.text = "Fare Estimate: $\(x+1.2+1) - $\(x+price3*0.23+6.4+1+2.24)"
                        
                    }else if( roundedDistance1 < 20)
                    { print ("base fare has reached4")
                        let y = roundedDistance1*0.63+basefare1
                        self.fare.text = "Fare Estimate: $\(y+1.2+1+4.95) - $\(y+price2*0.42+1.5+1+5.4+7.98)"
                        
                    }else if (roundedDistance1 < 30)
                    { print ("base fare has reached5")
                        let z = roundedDistance1*0.72+basefare2
                        self.fare.text = "Fare Estimate: $\(z+1.2+1+4.95+6.8) - $\(z+price1*0.67+1.5+1+10.4+7.3+3.67)"
                        
                    }else {
                        print ("base fare has reached6")
                        let b = roundedDistance1*0.89+basefare
                        self.fare.text = "Fare Estimate: $\(b+2+1+4.95+6.8+8.2) - $\(b+price3*0.89+6.5+1+5.4+7.3+9.1)"
                    }
                
                //fare.text = "Fare Estimate: \(roundedDistance1)"
                
                let DesAnno = MKPointAnnotation()
                
                DesAnno.coordinate = self.coords
                
                DesAnno.title = "Your Destination"
                
                self.map.addAnnotation(DesAnno)
                    
                let Desregion = MKCoordinateRegion(center: self.coords, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    
                self.map.setRegion(Desregion, animated: true)
                }
                
            }else{
                ShowDesButton.setTitle("", for: [])
            }
            
            
            let query = PFQuery(className: "RiderRequest")
            
            query.whereKey("username", equalTo: (PFUser.current()?.username)!)
            
            query.findObjectsInBackground(block: { (objects, error) in
                
                if let riderRequests = objects {
                    
                    for riderRequest in riderRequests {
                        
                        riderRequest["location"] = PFGeoPoint(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude)
                        
                        riderRequest.saveInBackground()
                        
                    }
                    
                }
                
                
            })
            
            
            
        }
        
        if riderRequestActive == true {
            
            
            if canceled == false {
            let query = PFQuery(className: "RiderRequest")
            
            query.whereKey("username", equalTo: (PFUser.current()?.username!)!)
            
            query.findObjectsInBackground(block: { (objects, error) in
                
                if let riderRequests = objects {
                    
                    for riderRequest in riderRequests {
                        
                        if let driverUsername = riderRequest["driverResponded"] as? String {
                            
                            let query = PFQuery(className: "DriverLocation")
                            
                            query.whereKey("username", equalTo: driverUsername)
                            
                            query.findObjectsInBackground(block: { (objects, error) in
                                
                                if let driverLocations = objects {
                                    
                                    for driverLocationObject in driverLocations {
                                        
                                        if let driverLocation = driverLocationObject["location"] as? PFGeoPoint {
                                            
                                            self.driverOnTheWay = true
                                            
                                            let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
                                            
                                            let riderCLLocation = CLLocation(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude)
                                            
                                            
                                            
                                            let distance = riderCLLocation.distance(from: driverCLLocation) / 1000
                                            
                                            let roundedDistance = round(distance * 100) / 100
                                            
                                            
                                            
                                            //tell rider that some driver has accept his request
                                            
                                            if self.i == 1 {
                                            self.displayAlert(title: "Driver has accepted your request !", message: "Your driver is on the way")
                                                self.i-=1
                                            }
                                            
                                             //self.driverDistanceLabel.text = "Your driver is \(roundedDistance)km away!"
                                            
                                            if roundedDistance <= 0.005{
                                                self.driverDistanceLabel.text = "Your driver was arrived"
                                            
                                            }else{
                                                self.driverDistanceLabel.text = "Your driver is \(roundedDistance)km away!"
                                            }
                                            
                                            
                                            if (roundedDistance < 2){
                                                self.waitTime.text = "Wait Time: 4 - 7 mins"
                                                
                                            }else if (roundedDistance < 5)
                                            {
                                                self.waitTime.text = "Wait Time: 10 - 13 mins"
                                                
                                            }else if (roundedDistance < 10)
                                            {
                                                self.waitTime.text = "Wait Time: 17 - 22 mins"
                                                
                                            }else if (roundedDistance < 17)
                                            {
                                                self.waitTime.text = "Wait Time: 28 - 33 mins"
                                                
                                            }else if (roundedDistance < 25)
                                            {
                                                self.waitTime.text = "Wait Time: 36 - 40 mins"
                                                
                                            }else if (roundedDistance < 34)
                                            {
                                                self.waitTime.text = "Wait Time: 45 mins - 1 hr"
                                                
                                            }else if (roundedDistance < 47)
                                            {
                                                 self.waitTime.text = "Wait Time: More than 1 hr"
                                            }
                                
                                            
                                            //self.callAnUberButton.setTitle("Your driver is \(roundedDistance)km away!", for: [])
                                            
                                            let latDelta = abs(driverLocation.latitude - self.userLocation.latitude) * 2 + 0.005
                                            
                                            let lonDelta = abs(driverLocation.longitude - self.userLocation.longitude) * 2 + 0.005
                                            
                                            let region = MKCoordinateRegion(center: self.userLocation, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta))
                                            
                                            self.map.removeAnnotations(self.map.annotations)
                                            
                                            self.map.setRegion(region, animated: true)
                                            
                                            let userLocationAnnotation = MKPointAnnotation()
                                            
                                            userLocationAnnotation.coordinate = self.userLocation
                                            
                                            userLocationAnnotation.title = "You"
                                            
                                            self.map.addAnnotation(userLocationAnnotation)
                                            
                                            let driverLocationAnnotation = MKPointAnnotation()
                                            
                                            driverLocationAnnotation.coordinate = CLLocationCoordinate2D(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
                                            
                                            driverLocationAnnotation.title = "Driver"
                                            
                                            self.map.addAnnotation(driverLocationAnnotation)
                                            
                                            //if driverUsername = riderRequest["DriverCanceled"]
                                            
                                        
                                        }
                                        
                                        
                                    }
                                    
                                }
                                
                                
                            })
                            
                        }
                        
                    }
                    
                }
                
            })
            }
            
            //if driver canceled the drive, notify rider
            //Also it should work similar with clicking the cancel uber
            
            
            
            let Cquery = PFQuery(className: "RiderRequest")
            
            Cquery.whereKey("username", equalTo: (PFUser.current()?.username!)!)
            
            Cquery.findObjectsInBackground(block: { (objects, error) in
                
                if let riderRequests = objects {
                    
                    for riderRequest in riderRequests {
                        if let driverName = riderRequest["DriverCanceled"] {
                            
                            self.canceled = true
                            
                            self.driverOnTheWay = false
                            
                            let query = PFQuery(className: "DriverLocation")
                            
                            query.whereKey("username", equalTo: driverName)
                            
                            query.findObjectsInBackground(block: { (objects, error) in
                                
                                if let driverLocations = objects {
                                    
                                    for driverLocationObject in driverLocations {
                                        
                                        if let driverLocation = driverLocationObject["location"] as? PFGeoPoint {
                            
                            self.displayAlert(title: "Your Driver has canceled your request", message: "If you need another Cuber, please call again.")
                            
                            self.callAnUberButton.setTitle("Request a cUber", for: [])
                            
                            self.riderRequestActive = false
                            
                            
                            self.waitTime.text = "Wait Time: "
                            self.driverDistanceLabel.text = "Driver Has Canceled Your Request"
                            let Reregion = MKCoordinateRegion(center: self.userLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                            self.map.setRegion(Reregion, animated: true)
                            
                            
                            let query = PFQuery(className: "RiderRequest")
                            
                            query.whereKey("username", equalTo: (PFUser.current()?.username)!)
                            
                            query.findObjectsInBackground(block: { (objects, error) in
                                
                                if let riderRequests = objects {
                                    
                                    for riderRequest in riderRequests {
                                        
                                        riderRequest.deleteInBackground()
                                        
                                    }
                                    
                                }
                                
                                
                            })
                            
                            
                            let DestinationQuery = PFQuery(className: "DestinationLocation")
                            
                            DestinationQuery.whereKey("username", equalTo: (PFUser.current()?.username)!)
                            
                            DestinationQuery.findObjectsInBackground(block: { (objects, error) in
                                
                                if let riderDestinations = objects {
                                    
                                    for riderDestination in riderDestinations {
                                        
                                        riderDestination.deleteInBackground()
                                        
                                    }
                                    
                                }
                                
                                
                            })
                                        }
                                    }
                                }
                            })
                            
                        }

                        
                    }
                }
            })
        
            
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
}
