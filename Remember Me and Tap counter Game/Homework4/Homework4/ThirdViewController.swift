//
//  ThirdViewController.swift
//  Homework4
//
//  Created by uics13 on 9/28/16.
//  Copyright © 2016 UIowa. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    

    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var tapsCountedLabel: UILabel!
    
    @IBOutlet weak var finalScoreLabel: UILabel!
    
    var timeLeft = 10
    var timer = Timer()
    var tapsCountedNumber = Int()
    
     var tapCounterValueToPass:String! // For segue
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (tapCounterValueToPass == nil){
            tapCounterValueToPass = String ("0")
        }
        
        let defaults = UserDefaults.standard
        defaults.set(tapCounterValueToPass, forKey: "tapCounterDefaultvalue")
        
        let thirdViewController = segue.destination as! MasterTableViewController
        thirdViewController.tapCounterDisplay = tapCounterValueToPass    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        finalScoreLabel.isHidden = true
        if (timelabel.text! == "10" || timelabel.text! == "0")
        {
            tapsCountedNumber = 0
            tapsCountedLabel.text = String (0)
            tapsCountedLabel.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func startGame(_ sender: AnyObject) {
      //  NSTimer.scheduledTimerWithInterval(1.0, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
        tapsCountedNumber = 0
        tapsCountedLabel.text = String (0)
       timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        tapsCountedLabel.isHidden = false
    }

    
    @IBAction func resetGame(_ sender: AnyObject?) {
        
        tapsCountedNumber = 0
        timer.invalidate()
        timelabel.text = String(10)
        timeLeft = 10
        tapsCountedLabel.text = String(0)
        finalScoreLabel.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent!) {
          tapsCountedNumber += 1
          tapsCountedLabel.text = String (tapsCountedNumber)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent!) {
        
        if (timelabel.text! == "10" || timelabel.text! == "0")
        {   tapsCountedNumber = 0
            tapsCountedLabel.text = String (0)
        }
    }
    
  

    func updateTimer() {
        timeLeft = timeLeft - 1
        timelabel.text = String(timeLeft)
        if(timeLeft == 0)
        {
            timer.invalidate()
            finalScoreLabel.isHidden = false
            finalScoreLabel.text = "Your Score is : \(tapsCountedNumber)"
            tapsCountedLabel.isHidden = true
            tapCounterValueToPass = String (tapsCountedNumber)
            print("tap counter segue value \(tapCounterValueToPass)")
            performSegue(withIdentifier: "tapCounterDisplaySegue", sender: self)
        
        }
    }
    

}
