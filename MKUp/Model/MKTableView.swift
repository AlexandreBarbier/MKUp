//
//  MKTableView.swift
//  MKUp
//
//  Created by Alexandre barbier on 19/10/14.
//  Copyright (c) 2014 Alexandre barbier. All rights reserved.
//

import UIKit
import Foundation

class MKTableView: MKView {
    var tableview = UITableView()
    var cellTitle = "Title"
    var cellDetail = "Detail"
    
    var delegate : protocol <UITableViewDataSource, UITableViewDelegate>? {
        didSet {
            tableview.delegate = self.delegate
            tableview.dataSource = self.delegate
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tableview = self.getMainSubview()!
        tableview.delegate = self.delegate
        cellTitle = aDecoder.decodeObjectForKey("cellTitle") as String
        cellDetail = aDecoder.decodeObjectForKey("cellDetail") as String
        self.longPressActions.append(UIAlertAction(title: "Customise Cell", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            var alert = UIAlertController(title: "Customize", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            var setT = UIAlertAction(title: "Set title", style: .Default, handler: { (_) -> Void in
                let textf = alert.textFields![0] as UITextField
                self.cellTitle = textf.text
                let textg = alert.textFields![1] as UITextField
                self.cellDetail = textg.text
                self.tableview.reloadData()
            })
            alert.addAction(setT)
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = self.cellTitle
            })
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = self.cellDetail
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.controller?.presentViewController(alert, animated: true, completion: nil)
        }))
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(cellTitle, forKey: "cellTitle")
        aCoder.encodeObject(cellDetail, forKey: "cellDetail")
    }
    
    override init() {
        super.init()
        
        tableview.frame = self.bounds
        tableview.backgroundColor = UIColor.clearColor()
        tableview.userInteractionEnabled = false
        tableview.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.addSubview(tableview)
        
        self.longPressActions.append(UIAlertAction(title: "Customise Cell", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            var alert = UIAlertController(title: "Customize", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            var setT = UIAlertAction(title: "Set title", style: .Default, handler: { (_) -> Void in
                let textf = alert.textFields![0] as UITextField
                self.cellTitle = textf.text
                let textg = alert.textFields![1] as UITextField
                self.cellDetail = textg.text
                self.tableview.reloadData()
            })
            alert.addAction(setT)
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = self.cellTitle
            })
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = self.cellDetail
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.controller?.presentViewController(alert, animated: true, completion: nil)
        }))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableview.frame = self.bounds
        self.clipsToBounds = true
        tableview.backgroundColor = UIColor.clearColor()
        tableview.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        tableview.userInteractionEnabled = false
        self.addSubview(tableview)
        
        self.longPressActions.append(UIAlertAction(title: "Customise Cell", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            var alert = UIAlertController(title: "Customize", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            var setT = UIAlertAction(title: "Set title", style: .Default, handler: { (_) -> Void in
                let textf = alert.textFields![0] as UITextField
                self.cellTitle = textf.text
                let textg = alert.textFields![1] as UITextField
                self.cellDetail = textg.text
                self.tableview.reloadData()
            })
            alert.addAction(setT)
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = self.cellTitle
            })
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = self.cellDetail
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.controller?.presentViewController(alert, animated: true, completion: nil)
        }))
    }
    
}