//
//  TestViewController.swift
//  Homework3
//
//  Created by uics13 on 9/19/16.
//  Copyright © 2016 UIowa. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

  
  
    @IBOutlet weak var headerLabel: UILabel!
    
    
    var headerString:String? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        headerLabel.text = headerString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
