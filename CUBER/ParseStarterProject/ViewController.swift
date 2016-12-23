//
//  ViewController.swift
//  CUBER
//
//  Created by uics13 on 10/29/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    func displayAlert(title: String, message: String) {
        
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertcontroller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertcontroller, animated: true, completion: nil)
        
    }
    
     @IBOutlet var usernameTextField: UITextField!
     @IBOutlet var passwordTextField: UITextField!
     @IBOutlet var signupSwitchButton: UIButton!
    // New Login and sign up activity
    
    @IBOutlet var SignUpButton: UIButton!
    
    @IBAction func SignUpAction(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "LoginToSignupSegue", sender: self)
    }
 
    @IBOutlet var LoginButton: UIButton!
    @IBAction func LoginAction(_ sender: AnyObject) {
        //self.performSegue(withIdentifier: "LoginToSignupSegue", sender: self)
        
        if usernameTextField.text == "" || passwordTextField.text == "" {
        
            displayAlert(title: "Error", message: "Username and password are required")
            print("Log In Not Successful")
            
            
        } else {
            
            print("Log In Successful")
            
            PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                
                if let error = error {
                    
                    var displayedErrorMessage = "Please try again later"
                    
                    let error = error as NSError
                    
                    if let parseError = error.userInfo["error"] as? String {
                        
                        displayedErrorMessage = parseError
                        
                        
                    }
                    
                    self.displayAlert(title: "Login  Failed", message: displayedErrorMessage)
                    
                } else {
                    
                    print("Log In Successful")
                    
                    if let isDriver = PFUser.current()?["isDriver"] as? Bool {
                        
                        if isDriver {
                            self.performSegue(withIdentifier: "showDriverViewController", sender: self)
                            //self.displayAlert(title: "Success", message: "You are Loggin in as Driver")
                            
                            
                        } else {
                            
                            
                            self.performSegue(withIdentifier: "showRiderViewController", sender: self)
                            //self.displayAlert(title: "Success", message: "You are Loggin in as Rider")
                            
                        }
                        
                        
                        
                    }
                    
                    
                }
                
                
            })
            
        }
        
        
    }
  


    
//***************************************************************************************************************************
    
    
    
    
    
   // @IBOutlet var userSignupSwitch: UISwitch!
    //var signUpMode = true
    
 
    

    
    
    //@IBOutlet var signupOrLoginButton: UIButton!
//    @IBAction func signupOrLogin(_ sender: AnyObject) {
//        
//        if usernameTextField.text == "" || passwordTextField.text == "" {
//            
//            displayAlert(title: "Error in form", message: "Username and password are required")
//            
//        } else {
//            
//            if signUpMode {
//                
//                let user = PFUser()
//                
//                user.username = usernameTextField.text
//                user.password = passwordTextField.text
//                
//                
//                user["isDriver"] = userSignupSwitch.isOn
//                
//                user.signUpInBackground(block: { (success, error) in
//                    
//                    if let error = error {
//                        
//                        var displayedErrorMessage = "Please try again later"
//                        
//                        let error = error as NSError
//                        
//                        if let parseError = error.userInfo["error"] as? String {
//                            
//                            displayedErrorMessage = parseError
//                            
//                            
//                        }
//                        
//                        self.displayAlert(title: "Sign Up Failed", message: displayedErrorMessage)
//                        
//                    } else {
//                        
//                        print("Sign Up Successful")
//                        
//                        if let isDriver = PFUser.current()?["isDriver"] as? Bool {
//                            
//                            if isDriver {
//                                
//                                self.performSegue(withIdentifier: "showDriverViewController", sender: self)
//                                
//                                
//                            } else {
//                                
//                                
//                                self.performSegue(withIdentifier: "showRiderViewController", sender: self)
//                                
//                            }
//                            
//                            
//                            
//                        }
//                        
//                    }
//                    
//                    
//                })
//                
//            } else {
//                
//                PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!, block: { (user, error) in
//                    
//                    if let error = error {
//                        
//                        var displayedErrorMessage = "Please try again later"
//                        
//                        let error = error as NSError
//                        
//                        if let parseError = error.userInfo["error"] as? String {
//                            
//                            displayedErrorMessage = parseError
//                            
//                            
//                        }
//                        
//                        self.displayAlert(title: "Login  Failed", message: displayedErrorMessage)
//                        
//                    } else {
//                        
//                        print("Log In Successful")
//                        
//                        if let isDriver = PFUser.current()?["isDriver"] as? Bool {
//                            
//                            if isDriver {
//                                
//                                self.performSegue(withIdentifier: "showDriverViewController", sender: self)
//                                
//                            } else {
//                                
//                                
//                                self.performSegue(withIdentifier: "showRiderViewController", sender: self)
//                                
//                            }
//                            
//                            
//                            
//                        }
//                        
//                        
//                    }
//                    
//                    
//                })
//                
//            }
//            
//        }
//        
//        
//        
//    }
//   
//    
//    @IBOutlet var driverLabel: UILabel!
//    @IBOutlet var riderLabel: UILabel!
//    
//    @IBAction func switchSignupMode(_ sender: AnyObject) {
//        
//        
//        if signUpMode {
//            
//            signupOrLoginButton.setTitle("Log In", for: [])
//            
//            signupSwitchButton.setTitle("Switch To Sign Up", for: [])
//            
//            signUpMode = false
//            
//            userSignupSwitch.isHidden = true
//            
//            riderLabel.isHidden = true
//            
//            driverLabel.isHidden = true
//            
//            
//        } else {
//            
//            signupOrLoginButton.setTitle("Sign Up", for: [])
//            
//            signupSwitchButton.setTitle("Switch To Log In", for: [])
//            
//            signUpMode = true
//            
//            userSignupSwitch.isHidden = false
//            
//            riderLabel.isHidden = false
//            
//            driverLabel.isHidden = false
//            
//        }
//        
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        
//        if let isDriver = PFUser.current()?["isDriver"] as? Bool {
//            
//            if isDriver {
//                
//                performSegue(withIdentifier: "showDriverViewController", sender: self)
//                
//                
//            } else {
//                
//                
//                self.performSegue(withIdentifier: "showRiderViewController", sender: self)
//                
//            }
//            
//            
//            
//        }
//        
//        
//        
//    }
//    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let isDriver = PFUser.current()?["isDriver"] as? Bool {
            
            if isDriver {
                
                performSegue(withIdentifier: "showDriverViewController", sender: self)
                
                
            } else {
                
                
                self.performSegue(withIdentifier: "showRiderViewController", sender: self)
                
            }
            
            
            
        }
        
        
        
    }

    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        
    }
//    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
