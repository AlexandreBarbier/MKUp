//
//  MKNavigationViewController.swift
//  MKUp
//
//  Created by Alexandre barbier on 24/12/14.
//  Copyright (c) 2014 Alexandre barbier. All rights reserved.
//

import UIKit

class MKNavigationViewController: UINavigationController {
    var project : MKProject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //doesn't work like this 
        for view in project.views {
            var viewController = UIViewController()
            viewController.view = view
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
