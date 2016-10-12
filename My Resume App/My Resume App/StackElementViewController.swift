//
//  StackElementViewController.swift
//  Homework3
//
//  Created by uics13 (Suhas V Kumar) on 9/18/16.
//  Copyright © 2016 UIowa. All rights reserved.
//

import UIKit

class StackElementViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var headerString:String? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        headerLabel.text = headerString
        
        if(headerLabel.text == "Education" ){
            let str1:String = "• 2016 - 2018: University of Iowa"
            let str2:String = "\n• 2010 - 2014: SJB Institute of Technology"
            let str3:String = "\n• 2008 - 2010: S.K.C.H"
            textView.text! = ("\(str1)"+"\(str2)"+"\(str3)")
        }
        
        if(headerLabel.text == "Work Experience" ){
            textView.text! = "• 2014 - 2016: Wipro Technologies"
            
        }
        
        if(headerLabel.text == "Projects" ){
            let str1:String = "• Secured Web Based Polling System Using Homomorphic Encryption Technique - using HTML|CSS|JSP|MY SQL"
            let str2:String = "\n• Online Hotel MAnagement System - using ASP.NET|SQL Server"
            let str3:String = "\n• Manchester City FC - using SharePoint|SQL Server"
            let str4:String = "\n• SHELL(VMI, Quality Bank, Enerfy Xchange) - using ASP.Net|SQL Server"
            textView.text! = ("\(str1)"+"\(str2)"+"\(str3)"+"\(str4)")
        }
        
        if(headerLabel.text == "Technical Skills"){
            let str1:String = "• C#"
            let str2:String = "\n• Java"
            let str3:String = "\n• Swift"
            let str4:String = "\n• HTML"
            let str5:String = "\n• CSS"
            let str6:String = "\n• JavaScript"
            let str7:String = "\n• PHP"
            let str8:String = "\n• Dot Net"
            let str9:String = "\n• RDBMS"
            textView.text! = ("\(str1)"+"\(str2)"+"\(str3)"+"\(str4)"+"\(str5)"+"\(str6)"+"\(str7)"+"\(str8)"+"\(str9)")
            
        }
        
        if(headerLabel.text == "Languages Known" ){
            let str1:String = "• English"
            let str2:String = "\n• Kannada"
            textView.text! = ("\(str1)"+"\(str2)")
            
        }
        
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
