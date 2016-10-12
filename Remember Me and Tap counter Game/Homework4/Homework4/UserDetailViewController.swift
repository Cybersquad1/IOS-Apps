//
//  UserDetailViewController.swift
//  Homework4
//
//  Created by uics13 on 9/28/16.
//  Copyright © 2016 UIowa. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    var passedValue:String!
    var caldDisplayfromSegue:String!
    var clickScorefromSegue: String!
    var isActive:Bool = false
    var activeUserName:String!
  
    
    @IBOutlet weak var activeBtn: UIButton!
    
    let date = NSDate()
 
    
    @IBOutlet weak var userNameValue: UILabel!
    
    @IBOutlet weak var activeLabelMsg: UILabel!
    @IBOutlet weak var activeBtnOutlet: UIButton!
    @IBOutlet weak var calDisplayLabel: UILabel!
    @IBOutlet weak var tapScoreDisplayLabel: UILabel!
    
    
    func isActiveUser() -> Bool
    {
        if(activeUserName == "\(passedValue!)")
        {
            print ("\(passedValue!) is active user")
            activeBtnOutlet.isHidden = true
            activeUserName = "\(passedValue!)"
            isActive = true
            return true
        }
        else
        {
            print ("\(passedValue!) is  NOT active user")
            activeBtnOutlet.isHidden = false
            isActive = false
            return false
            
         }
        
    }
    
  
    @IBAction func activeButtonfunction(_ sender: AnyObject) {
   
        
        let btnTitle = sender.currentTitle!
        if(btnTitle == "Active ?")
        {
            activeLabelMsg.text = ("\(passedValue!) is active on ") + ("\(date)") //show activation time
            activeUserName = "\(passedValue!)"
            isActive = true
            print("Active btn is pressed")
            print ("Active User is \(activeUserName)")
            
        }
        else
        {
            print(" Button is not active \(passedValue!)")
           
        }
        
        
        
        if(activeUserName == "\(passedValue!)")
        {
            print ("active name  == passed name ")
            print ("\(activeUserName!)")
            print ("\(passedValue!)")
            activeLabelMsg.text = ("\(passedValue!) is active on ") + ("\(date)")
            calDisplayLabel.text = ("Calculator Value: \(0)")
            tapScoreDisplayLabel.text = ("Tap Counter Score: \(0)")
        }
        else
        {
            
            print ("active name is not equal to passed name")
            print ("\(activeUserName!)")
            print ("\(passedValue!)")
            calDisplayLabel.text = ("Calculator Value: \(caldDisplayfromSegue!)")
            tapScoreDisplayLabel.text = ("Tap Counter Score: \(clickScorefromSegue!)")
            
        }
        
        
        
    }
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBAction func backBtnFunction(_ sender: AnyObject) {
        
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "MasterTableViewController")
        self.show(vc as! MasterTableViewController, sender: vc)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print ("view didi appear")
        if(caldDisplayfromSegue == nil)
        {
            caldDisplayfromSegue = "0"
        }
        if(clickScorefromSegue == nil)
        {
            clickScorefromSegue = "0"
        }

        
        
        if("\(activeUserName!)" == "\(passedValue!)")
        {
            print ("active name  == passed name ")
            print ("\(activeUserName!)")
            print ("\(passedValue!)")
            activeLabelMsg.text = ("\(passedValue!) is NOT active")
            calDisplayLabel.text = ("Calculator Value: \(caldDisplayfromSegue!)")
            tapScoreDisplayLabel.text = ("Tap Counter Score: \(clickScorefromSegue!)")
        }
        else
        {
            
            print ("active name is not equal to passed name")
            print ("\(activeUserName!)")
            print ("\(passedValue!)")
            calDisplayLabel.text = ("Calculator Value: \(0)")
            tapScoreDisplayLabel.text = ("Tap Counter Score: \(0)")
        
        }
 
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         print ("Active User is \(activeUserName)")
        
        
        print("View did Loaded  \(passedValue!)")
        activeBtnOutlet.isHidden = false
        userNameValue.text = ("Username: \(passedValue!)")
       // activeLabelMsg.text = ("\(passedValue!) is active on ") + ("\(date)") //show activation time
        calDisplayLabel.text = "Calculator Value: \(0)"
        tapScoreDisplayLabel.text = "Tap Counter Game Score: \(0)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
