//
//  MKButton.swift
//  MKUp
//
//  Created by Alexandre barbier on 02/10/14.
//  Copyright (c) 2014 Alexandre barbier. All rights reserved.
//

import UIKit

class MKButton: MKView {
    var button = UIButton()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.button = self.getMainSubview()!
        self.longPressActions.append(UIAlertAction(title: "Set title", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            var alert = UIAlertController(title: "Customize", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            var setT = UIAlertAction(title: "Set title", style: .Default, handler: { (_) -> Void in
                let textf = alert.textFields![0] as UITextField
                self.button.setTitle(textf.text, forState: UIControlState.Normal)
            })
            alert.addAction(setT)
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.controller?.presentViewController(alert, animated: true, completion: nil)
        }))
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.button.frame = CGRect(x: 0,y: 0,width: frame.size.width, height: frame.size.height)
        self.button.showsTouchWhenHighlighted = true
        self.button.setTitleColor(UIColor.MKGreenColor(), forState: UIControlState.Highlighted)
        self.button.setTitle("Button", forState: UIControlState.Normal)
        self.button.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.button.userInteractionEnabled = false
        self.addSubview(button)
        self.longPressActions.append(UIAlertAction(title: "Set title", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
           var alert = UIAlertController(title: "Customize", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            var setT = UIAlertAction(title: "Set title", style: .Default, handler: { (_) -> Void in
                let textf = alert.textFields![0] as UITextField
                self.button.setTitle(textf.text, forState: UIControlState.Normal)
            })
            alert.addAction(setT)
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in

            })
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.controller?.presentViewController(alert, animated: true, completion: nil)
        }))
    }
}