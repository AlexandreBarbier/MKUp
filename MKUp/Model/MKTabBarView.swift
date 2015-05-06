//
//  MKTabBarView.swift
//  MKUp
//
//  Created by Alexandre barbier on 17/01/15.
//  Copyright (c) 2015 Alexandre barbier. All rights reserved.
//

import UIKit

class MKTabBarView: MKView {
    var tabBar = UITabBar()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBar = self.getMainSubview()!
        self.longPressActions.append(UIAlertAction(title: "Set number of Item", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            var alert = UIAlertController(title: "Customize", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            var setT = UIAlertAction(title: "Set numbers of items", style: .Default, handler: { (_) -> Void in
                let textf = alert.textFields![0] as UITextField
                var nOI = textf.text.toInt()
                if let number = nOI {
                    var items = [UITabBarItem]()
                    for var i = 0; i < number; i++ {
                        
                        items.append(UITabBarItem(title: "item", image: nil, selectedImage: nil))
                    }
                    self.tabBar.setItems(items, animated: true)
                }
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
    
    override func colorPickerChooseColor(colorPicker:MKColorPickerController, color: UIColor) {
        self.tabBar.barTintColor = color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tabBar.frame = self.bounds
        self.tabBar.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.tabBar.userInteractionEnabled = false
        self.addSubview(tabBar)
        self.longPressActions.append(UIAlertAction(title: "Set number of Item", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            var alert = UIAlertController(title: "Customize", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            var setT = UIAlertAction(title: "Set numbers of items", style: .Default, handler: { (_) -> Void in
                let textf = alert.textFields![0] as UITextField
                var nOI = textf.text.toInt()
                if let number = nOI {
                    var items = [UITabBarItem]()
                    for var i = 0; i < number; i++ {

                        items.append(UITabBarItem(title: "item", image: nil, selectedImage: nil))
                    }
                self.tabBar.setItems(items, animated: true)
                }
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
