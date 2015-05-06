//
//  MKInput.swift
//  MKUp
//
//  Created by Alexandre barbier on 02/10/14.
//  Copyright (c) 2014 Alexandre barbier. All rights reserved.
//

import UIKit

class MKInput: MKView {
    var textF = UITextField()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textF = self.getMainSubview()!

        self.longPressActions.append(UIAlertAction(title: "Set placeholder", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            var alert = UIAlertController(title: "Customize", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            var setT = UIAlertAction(title: "Set placeholder", style: .Default, handler: { (_) -> Void in
                let alertText = alert.textFields![0] as UITextField
                self.textF.placeholder = alertText.text + ":"
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
        aCoder.encodeObject(self.textF, forKey: "textF")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textF.frame = CGRect(x: 0,y: 0, width: frame.size.width, height: frame.size.height)
        textF.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        textF.placeholder = "Input : "
        textF.textAlignment = NSTextAlignment.Center
        textF.userInteractionEnabled = false
        self.addSubview(textF)
        self.longPressActions.append(UIAlertAction(title: "Set placeholder", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            var alert = UIAlertController(title: "Customize", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            var setT = UIAlertAction(title: "Set placeholder", style: .Default, handler: { (_) -> Void in
                let alertText = alert.textFields![0] as UITextField
                self.textF.placeholder = alertText.text + ":"
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