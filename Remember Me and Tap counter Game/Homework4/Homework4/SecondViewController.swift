//
//  ViewController.swift
//  Calculator
//
//  Created by uics13(Suhas Kumar) on 9/7/16.
//  Copyright © 2016 UIowa. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    @IBOutlet private weak var history: UILabel!
    
    var userisenteringnumber = false //var is variable

    var calcValueToPass:String!
    
   
     //what happens when you click a button, IBAction takes care of that
    @IBAction func enternumber (sender:UIButton){
        let digit = sender.currentTitle! //let is constant, can't change it, current title is title of button, sender is the button, ! is for unwrapping
        if userisenteringnumber {
            display.text = display.text! + digit
        }else {
            display.text = digit
            userisenteringnumber = true
        }
    
    }
    
    
    
    @IBAction func plusorminus(sender: UIButton) {
        if (Double(display.text!)! > Double (0.00))
        {
            display.text = (String)(0.00 - Double(display.text!)!)

        }
        else if (Double(display.text!)! < Double (0.00))
        {
            // Since number is negative, make it positive.
            display.text = (String)(Double(0.00) - Double(display.text!)!);
 
        }
    }
    
    
    
    @IBAction func backspace(sender: UIButton) {
       let check = display.text!
       if check.range(of: "+") == nil
        {
            display.text = display.text
        }
        
        if !display.text!.isEmpty
        {
        let name: String = display.text!
        let truncated = name.substring(to: name.index(before: name.endIndex))
        display.text = truncated
        }
        
    }

    
    
    
    @IBAction func dot(sender: UIButton) {
        let digit = sender.currentTitle!
      
            if (userisenteringnumber == true && digit == "•")
            {
                display.text = display.text! + "."
            }
            else
            {
                userisenteringnumber = false
                display.text = display.text!
            }
 
    }
    
    
    var operandstack = Array<Double>()
    
    var operandstackdummy = Array<Double>()
  
    
    
    @IBAction func enter (){
        userisenteringnumber = false;
        operandstack.append(displayvalue)
        //history.text = "\(operandstack)"
        print("Operandstack = \(operandstack)")
        print ("history = \(history.text!)")
    }

    
    
    var displayvalue : Double {
       
                get{
                    return Double (display.text!)!
                    
                }set {
                    //To remove ".0" being displayed on the screen "
                        if newValue == floor (newValue){
                        display.text = "\(Double(newValue))"
                            if(display.text == "\(0.0)")
                            {
                                display.text = "\(0)"
                             
                                
                            }
        
                    }else {
                        display.text = "\(newValue)"
                         
                    }
                }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "calcDisplaySegue"){
            
            if calcValueToPass == nil{
                calcValueToPass = String ("0")
            }
            
            let defaults = UserDefaults.standard
            defaults.set(calcValueToPass, forKey: "caldefaultvalue")
            
            let secondViewController = segue.destination as! MasterTableViewController
            secondViewController.caldDisplay = calcValueToPass
        }
    }
    
    
    @IBAction func clear () {           //Clear method, to clear the display screen
        display.text = "\(0)"
        history.text = ""
        operandstack = [Double]() //clear all elements in array
        userisenteringnumber = false
        print("Operandstack = \(operandstack)")
    }
   
    
    
    var operationsymbforsecdisp = "" //creating this to capture the operation symbol for secondary display
    @IBAction func operate (sender: UIButton){
        let operation = sender.currentTitle!
        operationsymbforsecdisp = operation
        print ("\(operation)")
        if userisenteringnumber{
            enter()
        }
        
        let size = operandstack.count
        if(size > 1){
        switch operation {
            case "+":   performOperation{$1 + $0}
            case "/": performOperation{$1 / $0}
            case "-": performOperation{$1 - $0}
            case "X": performOperation{$0 * $1}
            case "√": performOperation {sqrt($0)}   //calculating square root of operand
            case "Sin": performOperation {sin($0)} //calculating sine of operand
            case "Cos": performOperation {cos($0)} // calculating cosine of operand
            default: break
                         }
            }
        else     //if no. of operands are less less than 1, by default second operand is 0
            {
                switch operation {
                case "+": performOperation{$0 + 0}
                case "/": performOperation{0 / $0}
                case "-": performOperation{0 - $0}
                case "X": performOperation{$0 * 0}
                case "√": performOperation {sqrt($0)}
                case "Sin": performOperation {sin($0)}
                case "Cos": performOperation {cos($0)}
                default: break
                                }
            
            }
    }

    
  
 
    func performOperation (operation: (Double, Double) -> Double) {
        if operandstack.count >= 2 {
            let a:Double = operandstack.removeLast()
            let b:Double = operandstack.removeLast()
            displayvalue = operation (a,b)
            history.text = ("\(b,a)\(operationsymbforsecdisp)\("=")\(display.text!)") //display history of binary operations
            print ("\(a,b)")
            enter()
        }else {
            operandstack = [Double]() //clear all elements in array
            print("Operandstack = \(operandstack)")
        
            enter()
        }
        
        calcValueToPass = display.text!
        print("segue value \(calcValueToPass)")
        performSegue(withIdentifier: "calcDisplaySegue", sender: self)
        self.performSegue(withIdentifier: "calcDisplaySegue", sender: self)
        print("unwind segue called")
    }
 
    
    // Declaring it as private method to eliminate overloading error, objective-C
    private func performOperation (operation: (Double) -> Double) {
        if operandstack.count >= 1 {
            let c:Double = operandstack.removeLast()
            displayvalue = operation (c)
            history.text = ("\(c)\(operationsymbforsecdisp)\("=")\(display.text!)")//displays history of unary operations
            enter()
        }
    }
  
        
        
    func add (op1: Double, op2: Double) ->Double {
            return  op1 + op2
    
    }
    func subtract(op1: Double, op2: Double) ->Double {
            return op1 - op2
    }
        
    func multiply (op1: Double, op2: Double) ->Double {
            return op1 * op2
    }
        
    func divide (op1: Double, op2: Double) ->Double {
        if (op2 == 0)
        {
            display.text = "Division by Zero"
            
            enter()
            userisenteringnumber = false
            return 0.0
        }else {
        return op1 / op2
        }
    }

    
    
    
    
var calculatorConstants = [ "π": M_PI]//creating dictionary for constants and symbols, M_PI represents π.
    
    @IBAction func πevaluation(sender: UIButton) {
        let constant = sender.currentTitle!
        if userisenteringnumber{
            enter() // this will put the operand of the stack on display
        }
        display.text = "\(calculatorConstants[constant]!)"
        enter() // will give the value of the π evaluation
        userisenteringnumber = false
    }
    
}
