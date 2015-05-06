//
//  NotesViewController.swift
//  MKUp
//
//  Created by Alexandre barbier on 30/11/14.
//  Copyright (c) 2014 Alexandre barbier. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController, UITextViewDelegate {
    var project : MKProject?
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var noteTextview: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topView.backgroundColor = UIColor.MKGreenColor()
        self.noteTextview.backgroundColor = UIColor.MKWhiteColor()
        self.closeButton.setTitleColor(UIColor.MKBrownColor(), forState: UIControlState.Normal)
        self.noteTextview.scrollEnabled = false
        if let proj = project {
            self.noteTextview.attributedText = proj.notes
        }
        self.noteTextview.becomeFirstResponder();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func closeTouch(sender: AnyObject) {
        if let proj = project {
            proj.notes = self.noteTextview.attributedText
            proj.save()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
