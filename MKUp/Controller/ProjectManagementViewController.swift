//
//  ProjectManagementViewController.swift
//  MKUp
//
//  Created by Alexandre barbier on 07/10/14.
//  Copyright (c) 2014 Alexandre barbier. All rights reserved.
//

import UIKit

class ProjectManagerViewController: UITableViewController {
    
    var displayedDataSource : [MKProject]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayedDataSource = MKProject.listAllProject()
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.backgroundColor = UIColor.MKGreyColor()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = self.displayedDataSource {
            return array.count
        }
        else {
            return 0
        }
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {

        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            MKProject.deleteProject(self.displayedDataSource![indexPath.row].name)
            self.displayedDataSource?.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.presentingViewController != nil {
            var pres = self.presentingViewController as! ViewController
            pres.loadProject(self.displayedDataSource![indexPath.row])
            self.closeView()
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header      = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                           width: self.view.frame.size.width,
                                          height: 50))
        
        var close       = UIButton(frame: CGRect(x: self.view.frame.size.width - 58,
                                                 y: 0,
                                             width: 50,
                                            height: 50))
        
        var addProject  = UIButton(frame: CGRect(x: 8,
                                                 y: 0,
                                             width: 50,
                                            height: 50))
        
        var title       = UILabel(frame: header.frame)
        
        addProject.setTitle("New", forState: UIControlState.Normal)
        addProject.addTarget(self, action: "createNewProject", forControlEvents: UIControlEvents.TouchUpInside)
        addProject.setTitleColor(UIColor.MKBrownColor(), forState: UIControlState.Normal)
        addProject.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin
        
        close.setTitle("Close", forState: UIControlState.Normal)
        close.addTarget(self, action: "closeView", forControlEvents: UIControlEvents.TouchUpInside)
        close.setTitleColor(UIColor.MKBrownColor(), forState: UIControlState.Normal)
        close.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
        
        title.text = "Projects"
        title.textAlignment = NSTextAlignment.Center
        title.textColor = UIColor.MKDarkBrownColor()
        title.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin
        
        header.backgroundColor = UIColor.MKGreenColor()
        header.addSubviews([addProject,close,title])
        return header
    }
    
    func closeView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func createNewProject() -> Void {
        var alert = UIAlertController(title: "Project Name", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        var setT = UIAlertAction(title: "Create", style: .Default, handler: { (_) -> Void in
            let name = alert.textFields![0] as! UITextField
            var project = MKProject(name: name.text)
            if self.presentingViewController != nil {
                var pres = self.presentingViewController as! ViewController
                pres.loadProject(project)
                self.closeView()
            }
            
        })
        alert.addAction(setT)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "name"
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        cell.backgroundColor = UIColor.MKWhiteColor()
        var currentProject = self.displayedDataSource![indexPath.row]
        cell.textLabel!.text = currentProject.name
        cell.textLabel!.textColor = UIColor.MKBrownColor()
        cell.imageView!.image = currentProject.preview
        cell.detailTextLabel!.text = "last update date : \(currentProject.update)"
        cell.detailTextLabel!.textColor = UIColor.MKGreyColor()
        return cell
    }
}
