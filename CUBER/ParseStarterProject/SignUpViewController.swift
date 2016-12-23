//
//  SignUpViewController.swift
//  CUBER
//
//  Created by uics13 on 12/1/16.
//  Copyright © 2016 Parse. All rights reserved.
//


import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    func displayAlert(title: String, message: String) {
        
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertcontroller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertcontroller, animated: true, completion: nil)
        
    }
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var alreadyHaveAccount: UIButton!
    
    @IBOutlet var switchbutton: UISwitch!
    
    @IBOutlet var signupButton: UIButton!
    
    var signUpMode = true
    
    @IBAction func signupAction(_ sender: AnyObject) {
        
        if username.text == "" || password.text == "" {
            
            displayAlert(title: "Error in form", message: "Username and password are required")
            
        } else {
            
            
            if signUpMode {
                
                let user = PFUser()
                
                user.username = username.text
                user.password = password.text
                
                
                user["isDriver"] = switchbutton.isOn
                
                user.signUpInBackground(block: { (success, error) in
                    
                    if let error = error {
                        
                        var displayedErrorMessage = "Please try again later"
                        
                        let error = error as NSError
                        
                        if let parseError = error.userInfo["error"] as? String {
                            
                            displayedErrorMessage = parseError
                            
                            
                        }
                        
                        self.displayAlert(title: "Sign Up Failed", message: displayedErrorMessage)
                        
                    } else {
                        
                        print("Sign Up Successful")
                        
                        if let isDriver = PFUser.current()?["isDriver"] as? Bool {
                            
                            if isDriver {
                                
                                self.performSegue(withIdentifier: "ShowRequestList", sender: self)
                                
                                
                            } else {
                                
                                
                                self.performSegue(withIdentifier: "ShowRiderPage", sender: self)
                                
                            }
                            
                            
                            
                        }

                        
                    }
                    
                    
                })
                
                
            }
            
        }
    }
    
    
    @IBAction func alreadyHaveAccount(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "AlreadyHaveAccountToLoginSegue", sender: self)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.username.delegate = self
        self.password.delegate = self
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
