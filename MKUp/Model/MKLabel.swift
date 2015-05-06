//
//  MKLabel.swift
//  MKUp
//
//  Created by Alexandre barbier on 05/11/14.
//  Copyright (c) 2014 Alexandre barbier. All rights reserved.
//

import UIKit

class MKLabel: MKView, MKColorPickerDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var label = UILabel()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.label = self.getMainSubview()!
        self.label.textAlignment = NSTextAlignment.Center
        self.customisationAction.updateValue(textColor, forKey: "textColorIcon")
        self.longPressActions.append(UIAlertAction(title: "Set text", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            var alert = UIAlertController(title: "Customize", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            var setT = UIAlertAction(title: "Set title", style: .Default, handler: { (_) -> Void in
                let textf = alert.textFields![0] as UITextField
                self.label.text = textf.text
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = CGRect(x: 0,y: 0,width: frame.size.width,height: frame.size.height)
        label.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        label.backgroundColor = UIColor.clearColor()
        label.numberOfLines = 0
        label.text = "Label."
        label.userInteractionEnabled = false
        label.textColor = UIColor.blackColor()
        label.textAlignment = NSTextAlignment.Center
        self.addSubview(label)
        
        self.customisationAction.updateValue(textColor, forKey: "textColorIcon")
        self.longPressActions.append(UIAlertAction(title: "Set text", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            var alert = UIAlertController(title: "Customize", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            var setT = UIAlertAction(title: "Set text", style: .Default, handler: { (_) -> Void in
                let textf = alert.textFields![0] as UITextField
                self.label.text = textf.text
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
    
    override func colorPickerChooseColor(colorPicker:MKColorPickerController, color: UIColor) {
        if colorPicker.view.tag == 1500 {
            super.colorPickerChooseColor(colorPicker, color: color)
        }
        else {
            self.label.textColor = color
        }
    }
    
    func textColor(sender:UIButton)-> Void {
        
        var t = MKColorPickerController(nibName: "MKColorPickerViewController", bundle: nil)
        t.delegate = self
        
        if let controller = self.controller {
            t.view.center = controller.view.center
            controller.view.addSubview(t.view)
            controller.addChildViewController(t)
        }
        t.currentColor = self.label.textColor
    }
    
}
