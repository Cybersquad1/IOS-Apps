//
//  MasterTableViewController.swift
//  Homework4
//
//  Created by uics13 on 9/28/16.
//  Copyright © 2016 UIowa. All rights reserved.
//

import UIKit

class MasterTableViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    //2 protocols are UITableViewDataSource, UITableViewDelegate ... if we didn't create table view controller, rather created view controller and added table view, we nee to inherit  UITableViewDAtaSource and UITableView Delegate
    // we  need to add no.of rows in section and cell for row at functions when we use those protocols
    
    var caldDisplay:String!
    var tapCounterDisplay:String!
    var selectedName:String!

    @IBOutlet weak var tableView: UITableView!
    var userArray : [User] = []
    
    //we want the data to be appeared as soon as table view appers, so define View will appear
    
    override func viewWillAppear(_ animated: Bool) {
        //get the data from core data
        getData()
        
        //reload the table view
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
   
    
    
    func getData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            userArray = try context.fetch(User.fetchRequest())
        }
        catch {
            print ("Fetching Failed")
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            let user = userArray[indexPath.row]
            context.delete(user)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do{
                userArray = try context.fetch(User.fetchRequest())
            }
            catch {
                print ("Delete Succeeded")
            }
        }
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
 //   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
 //       return userArray.count
  //  }
    
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell =  UITableViewCell()
        //Configure the cell...
       let user = userArray[indexPath.row]
        cell.textLabel?.text = user.name!
        return cell
    }
    
    
    var valueToPass:String!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        //get cell label
        let indexPath = tableView.indexPathForSelectedRow;
        let currentCell = tableView.cellForRow(at: indexPath!)as UITableViewCell!;
        
        let defaults = UserDefaults.standard
        defaults.set(valueToPass, forKey: "selectedName")

        
        selectedName = currentCell!.textLabel!.text
        performSegue(withIdentifier: "showDetails", sender: self)
        
        
        
        
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
    
    
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
     override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if (caldDisplay == nil){
            caldDisplay = String("0")
        }
        
        if (tapCounterDisplay == nil){
            caldDisplay = String("0")
        }
        
        if (selectedName == nil){
            selectedName = String("Suhas")
        }
        
        
        let defaults1 = `UserDefaults`.standard
        caldDisplay = defaults1.object(forKey: "caldefaultvalue") as! String
        caldDisplay = caldDisplay!
        print("Calculator NS default value \(caldDisplay)")
        
        let defaults2 = `UserDefaults`.standard
        tapCounterDisplay = defaults2.object(forKey: "tapCounterDefaultvalue") as! String
        print("Tap Counter NS default value \(tapCounterDisplay)")
        
        let defaults3 = `UserDefaults`.standard
        valueToPass = defaults3.object(forKey: "selectedName") as? String
        print("default Name value \(selectedName)")
        
        
        if(segue!.identifier == "showDetails"){
            let secondViewController = segue?.destination as! UserDetailViewController
            secondViewController.passedValue = selectedName
            secondViewController.caldDisplayfromSegue = caldDisplay
            secondViewController.clickScorefromSegue = tapCounterDisplay
            secondViewController.activeUserName = selectedName
        }
        
        
   
        }
        
    
    
    
}

