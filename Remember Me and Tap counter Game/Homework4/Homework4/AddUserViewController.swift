//
//  AddUserViewController.swift
//  Homework4
//
//  Created by uics13 on 9/28/16.
//  Copyright © 2016 UIowa. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
   
  //  @IBOutlet var noteTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addUserBtn(_ sender: AnyObject) {
       //when you want to interact with DB, you have to create contextt container. 
        //when you add data model explicitly, name it as is is in the class name
        //don't rename the data model, else you will have hard time fixing that
        
        //When you add core data into application , check if you have renamned your project in the persisten
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // always write this when working with core date
        //persistent Container is on core data, AppDelegate file
        let user = User(context: context)
        user.name = nameTextField.text! //haven't checked for empty strings
       
        //save the data to core data , save Context is in Core Data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
        
    }

   

}
