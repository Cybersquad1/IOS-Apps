//
//  DriverViewController.swift
//  CUBER
//
//  Created by uics13 on 11/15/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class DriverViewController: UITableViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    var requestUsernames = [String]() //array of username
    var requestLocations = [CLLocationCoordinate2D]() //allow us to use range of swift methods to find distance between locations.
    
    var userLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "driverLogoutSegue" {
            
            locationManager.stopUpdatingLocation()
            
            PFUser.logOut()
            
            self.navigationController?.navigationBar.isHidden = true // will stop the navigation bar to continue on start page
            
        } else if segue.identifier == "showRiderLocationViewController"{
            
            // segue.destinationViewController is now segue.destination
            if let destination = segue.destination as? RiderLocationViewController {
                
                if  let row = tableView.indexPathForSelectedRow?.row {
                    destination.requestLocation = requestLocations[row]
                    destination.requestUsername = requestUsernames[row]
                }
            }
            print(tableView.indexPathForSelectedRow?.row)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        locationManager.delegate = self //set the delegate to view controller .. aka self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //for best accuracy
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }

    //did update function
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location?.coordinate {
            let query = PFQuery(className: "RiderRequest")
            userLocation = location
            print(location)
            
            
            //query to find if there is a rider's request that driver has responded to. Update the location of driver if he has responded to rider's request.
            let driverLocationQuery = PFQuery(className: "DriverLocation")
            
           // query.whereKey("username", equalTo: (PFUser.current()?.username!)!)
            driverLocationQuery.whereKey("username", equalTo: (PFUser.current()?.username!)!)
            driverLocationQuery.findObjectsInBackground(block: { (objects, error) in
                if let driverLocations = objects {
                    for driverLocation in driverLocations {
                        driverLocation["location"] = PFGeoPoint(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude)
                        driverLocation.deleteInBackground()
                    }
                 
                }
                let driverLocation = PFObject(className: "DriverLocation")
                driverLocation["username"] = PFUser.current()?.username
                driverLocation["location"] = PFGeoPoint(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude)
                driverLocation.saveInBackground()
                
            })
            
            
            
            
            
            query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: location.latitude, longitude: location.longitude)) //near geopoint request //this also gives nearest users distance ....
            
            
            query.limit = 10 //limiting the users to 10
            
            query.findObjectsInBackground(block: { (objects, error) in
                
                if let riderRequests = objects {
                    
                    self.requestUsernames.removeAll() // to prevent loading the data evrytime it loads .....
                    self.requestLocations.removeAll()
                    print("Results")
                    
                    for riderRequest in riderRequests {
                        if let username = riderRequest["username"] as? String {
                            if riderRequest["driverResponded"] == nil {
                                
                                let driverCLLocation1 = CLLocation(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude)
                                
                                let riderCLLocation1 = CLLocation(latitude: (riderRequest["location"] as AnyObject).latitude, longitude: (riderRequest["location"] as AnyObject).longitude)
                            
                                
                                let distance1 = driverCLLocation1.distance(from: riderCLLocation1)/1000 //to find the distance
                                
                                let roundedDistance1 = round(distance1 * 100)/100
                                
                                if roundedDistance1 < 48 {
                                self.requestUsernames.append(username) //updates username array with user requests
                                self.requestLocations.append(CLLocationCoordinate2D(latitude: (riderRequest["location"] as AnyObject).latitude, longitude: (riderRequest["location"] as AnyObject).longitude))
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                } else {
                    print ("No Results")
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return 4
        return requestUsernames.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //Find the distance between userLocation requestLocations[indexPath.row]
        let driverCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        let riderCLLocation = CLLocation(latitude: requestLocations[indexPath.row].latitude, longitude: requestLocations[indexPath.row].longitude)
        
        let distance = driverCLLocation.distance(from: riderCLLocation)/1000 //to find the distance
        
        let roundedDistance = round(distance * 100)/100 //to reduce to 2 decimal places
        
        cell.textLabel?.text = requestUsernames[indexPath.row] + " - \(roundedDistance) Km away"
        
        //cell.textLabel?.text = "Test"
        
        /*
        if roundedDistance < 48 { //displays user request who are within 30 miles
      
            cell.textLabel?.text = requestUsernames[indexPath.row] + " - \(roundedDistance) Km away"
        
        }
        else {
            
            cell.textLabel?.text = " "
            
        }*/
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
