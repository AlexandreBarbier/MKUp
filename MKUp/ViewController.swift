//
//  ViewController.swift
//  MKUp
//
//  Created by Alexandre barbier on 01/10/14.
//  Copyright (c) 2014 Alexandre barbier. All rights reserved.
//

import UIKit
import ABUIKit

class ViewController: UIViewController,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UITextViewDelegate, MKViewDelegate,
UIDocumentInteractionControllerDelegate,
UITableViewDataSource,
UITableViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource {

    var selectedView : MKView?
    var currentProject : MKProject?
    var projectRootView = UIScrollView()
    var currentView = MKView()
    var buttonTools : ABExpendableButton = ABExpendableButton(orientation: .Vertical, borderColor : UIColor.MKDarkBrownColor(), backColor: UIColor.MKWhiteColor())
    var projectTools : ABExpendableButton = ABExpendableButton(orientation: .Horizontal, borderColor : UIColor.MKDarkBrownColor(), backColor: UIColor.MKWhiteColor())
    var goLeftbutton : UIButton = UIButton()
    var goRightbutton : UIButton = UIButton()
    var viewNameLabel = UILabel()
    var isInPreviewMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonTools.horizontalDirection = .Left
        buttonTools.verticaleDirection = .Up
        buttonTools.addVerticalButton(["inputIcon": addInput,"projectList": addTableView,"imageIcon": addImage,"listIcon": addCollectionView,"buttonIcon": addButton,"textIcon": addText, "type": addLabel, "searchIcon": addSearchBar])
        projectTools.horizontalDirection = .Left
        projectTools.addHorizontalButton(["saveIcon": saveToolButtonTouched, "projectList" : projectToolButtonTouched, "addViewIcon": addViewButton,  "settings": showProject])

        projectTools.frame.origin = CGPoint(x: self.view.frame.width - projectTools.frame.width, y:22.0)
        buttonTools.frame.origin = CGPoint(x: self.view.frame.width - buttonTools.frame.width,y: self.view.frame.height - buttonTools.frame.height)
        buttonTools.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin
        projectTools.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleBottomMargin
        goLeftbutton.frame = CGRect(x: 8,y: self.view.frame.height - 52,width: 44,height: 44)
        goRightbutton.frame = CGRect(x: 60,y: self.view.frame.height - 52,width: 44,height: 44)
        goRightbutton.circle()
        goLeftbutton.circle()
        goLeftbutton.setImage(UIImage(named: "leftIcon"), forState: UIControlState.Normal)
        goRightbutton.setImage(UIImage(named: "rightIcon"), forState: UIControlState.Normal)
        goRightbutton.backgroundColor = UIColor.MKWhiteColor()
        goLeftbutton.backgroundColor = UIColor.MKWhiteColor()
        goLeftbutton.border(UIColor.MKDarkBrownColor(), width: 1.0)
        goRightbutton.border(UIColor.MKDarkBrownColor(), width: 1.0)
        goLeftbutton.addTarget(self, action: "changePage:", forControlEvents: UIControlEvents.TouchUpInside)
        goRightbutton.addTarget(self, action: "changePage:", forControlEvents: UIControlEvents.TouchUpInside)
        goLeftbutton.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin
        goRightbutton.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin
        viewNameLabel.frame = self.view.bounds
        viewNameLabel.font = UIFont.boldSystemFontOfSize(36)
        viewNameLabel.text = "View 1"
        viewNameLabel.textColor = UIColor.MKGreyColor().colorWithAlphaComponent(0.3)
        viewNameLabel.textAlignment = NSTextAlignment.Center
        viewNameLabel.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        
        
        self.view.addSubviews([viewNameLabel,projectRootView,projectTools,buttonTools,goLeftbutton,goRightbutton])
        projectRootView.frame = self.view.frame
        projectRootView.contentSize = self.view.frame.size
        projectRootView.pagingEnabled = true
        projectRootView.bounces = false
        projectRootView.showsHorizontalScrollIndicator = false
        projectRootView.scrollEnabled = false
        projectRootView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        projectRootView.backgroundColor = UIColor.MKGreyColor().colorWithAlphaComponent(0.2)
        var doubleTap = UITapGestureRecognizer(target: self, action: "previewMode:")
        doubleTap.numberOfTapsRequired = 2
        self.projectRootView.addGestureRecognizer(doubleTap)
        if let currentProj = MKProject.getLastOpenedProject() {
            currentProject = currentProj
            if currentProject!.name != "" {
                self.loadProject(currentProject!)
            }
        }
        
        self.buttonTools.changedOrientation = {(orientation:ABOrientation) in
            switch orientation {

            case .Vertical, .None :
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.goLeftbutton.alpha = 1.0
                    self.goRightbutton.alpha = 1.0
                    }, completion: { (finished) -> Void in
                        
                })
            case .Horizontal:
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.goLeftbutton.alpha = 0.0
                    self.goRightbutton.alpha = 0.0
                    }, completion: { (finished) -> Void in
                        
                })

            default :
                break
            }
        }
    }
    
    func changePage(sender:UIButton?) -> Void {
        if let button = sender {

            if button == goLeftbutton {
                var offset = projectRootView.contentOffset.x - self.view.frame.size.width
                if offset % self.view.frame.width != 0 {
                    offset -= offset % self.view.frame.width
                }
                self.projectRootView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
                goRightbutton.enabled = true
                if offset <= 0 {
                    button.enabled = false
                    offset = 0;
                }
                let index = Int(offset / self.view.frame.size.width)
                viewNameLabel.text = "View \(index + 1)"
                self.currentView = currentProject!.views[index] as MKView
            }
            else {
                var offset = projectRootView.contentOffset.x + self.view.frame.size.width
                if offset % self.view.frame.width != 0 {
                    if offset + offset % self.view.frame.width < projectRootView.contentSize.width {
                        offset += (self.view.frame.width - (offset % self.view.frame.width))
                    }
                                       
                }
                if offset + self.view.frame.width >= projectRootView.contentSize.width {
                    button.enabled = false
                    offset = projectRootView.contentSize.width - self.view.frame.width
                }
                self.projectRootView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
                goLeftbutton.enabled = true
                var index = Int(offset / self.view.frame.size.width)
                viewNameLabel.text = "View \(index + 1)"
                if index > currentProject!.views.count - 1 {
                    index = currentProject!.views.count - 1
                }
                self.currentView = currentProject!.views[index] as MKView
            }
        }
        else {
            var pageOffset = Int(projectRootView.contentOffset.x / self.view.bounds.width)
            var offset = CGFloat(pageOffset) - self.view.frame.size.width
            goRightbutton.enabled = true
            if offset <= 0 {
                self.goLeftbutton.enabled = false
            }
            if projectRootView.contentSize.width == self.view.frame.width {
                self.goRightbutton.enabled = false
            }
            self.currentView = currentProject!.views[0] as MKView
        }
    }
    
    func previewMode(sender:UIButton) {
        self.isInPreviewMode = !self.isInPreviewMode

        UIView.animateWithDuration(0.3, animations: { () -> Void in
            var alpha = self.projectTools.alpha
            self.projectTools.alpha = 1 - alpha
            self.buttonTools.alpha = 1 - alpha

            self.goLeftbutton.alpha = 1 - alpha
            self.goRightbutton.alpha = 1 - alpha
            self.viewNameLabel.alpha = 1 - alpha

        }) { (finished) -> Void in
            if (finished) {
                self.projectTools.hidden = self.isInPreviewMode
                self.buttonTools.hidden = self.isInPreviewMode
                self.projectRootView.scrollEnabled = self.isInPreviewMode
                self.goLeftbutton.hidden = self.isInPreviewMode
                self.goRightbutton.hidden = self.isInPreviewMode
                self.viewNameLabel.hidden = self.isInPreviewMode
                self.currentProject!.isInPreview = self.isInPreviewMode
            }
        }

    }
    
    
    func showProject(sender:UIButton) {
        var projectVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProjectDetailVC") as! ProjectDetailViewController
        projectVC.project = currentProject!
        projectVC.completion = { (selectedIndex:Int) -> Void in
            var offset = CGFloat(selectedIndex) * self.view.frame.size.width
            self.projectRootView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
            self.viewNameLabel.text = "View \(Int(offset / self.view.frame.size.width) + 1)"
        }
        self.presentViewController(projectVC, animated: true) { () -> Void in
            
        }
    }
    
    func addViewButton(sender:UIButton) {
        currentProject!.nbView += 1
        self.projectRootView.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(currentProject!.nbView), height: self.view.frame.size.height)
        var offset = self.projectRootView.contentOffset
        offset.x = CGFloat(currentProject!.nbView - 1) * self.view.frame.size.width
        viewNameLabel.text = "View \(Int(offset.x / self.view.frame.size.width) + 1)"
        self.projectRootView.contentOffset = offset
        self.currentView = MKView(frame: CGRect(x: offset.x, y:0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.currentView.controller = self
        self.currentView.viewDelegate = self
        self.currentView.project = self.currentProject
        self.currentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        self.currentProject!.views.append(self.currentView)
        self.projectRootView.insertSubview(self.currentView, belowSubview: self.projectTools)
        goLeftbutton.enabled = true
        goRightbutton.enabled = false
    }
    
    func saveToolButtonTouched(sender: UIButton?) {
        if currentProject?.name == "" {
            var alert = UIAlertController(title: "Project Name", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            var setT = UIAlertAction(title: "Save", style: .Default, handler: { (_) -> Void in
                let name = alert.textFields![0] as! UITextField
                self.currentProject = MKProject(name: name.text)
                self.saveProject(nil)
                self.loadProject(self.currentProject!)
            })
            alert.addAction(setT)
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = "name"
            })

            if (currentProject?.views.count != 0) {
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                }))
            }
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            self.saveProject(nil)
        }
    }
    
    func loadProject(project:MKProject) -> Void {
        if currentProject != nil && currentProject != project {
            currentProject!.removeFromView()
            currentProject = project
        }
        
        if let project = currentProject {
            self.projectRootView.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(project.nbView), height: self.view.frame.size.height)
            self.changePage(nil)
            project.rootView = self.projectRootView
            if project.views.count == 1 {
               var firstView = project.views[0] as MKView
                firstView.frame = self.view.bounds

            }
            self.currentView = project.views[0] as MKView

            for v : MKView in project.views {
                v.controller = self
                v.viewDelegate = self
                self.projectRootView.insertSubview(v, belowSubview: self.projectTools)
                
                for subV : UIView in v.subviews as! [UIView] {
                    if subV.isKindOfClass(MKView.self) {
                        var k = subV as! MKView
                        k.controller = self
                        k.viewDelegate = self
                    }
                    if subV.isKindOfClass(MKImageView.self) {
                        var k = subV as! MKImageView
                        k.delegate = self
                    }
                    if subV.isKindOfClass(MKText.self) {
                        var k = subV as! MKText
                        k.delegate = self
                    }
                    if subV.isKindOfClass(MKTableView.self) {
                        var k = subV as! MKTableView
                        k.delegate = self
    
                    }
                    if subV.isKindOfClass(MKCollectionView.self) {
                        var k = subV as! MKCollectionView
                        k.delegate = self
                    }
                }
            }
        }
        else {
            currentProject = MKProject(name: "test")
        }
    }
    
    func projectToolButtonTouched(sender: UIButton) {
        var projectVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProjectManagerVC") as! ProjectManagerViewController
        self.presentViewController(projectVC, animated: true, completion: nil)
    }
    
   
    
    func saveProject(sender:UIButton?) {
        self.currentProject?.save()
        var infoView = UILabel(frame: CGRect(x: 0,y: 0,width: 150,height: 50))
        infoView.backgroundColor = UIColor.MKGreyColor().colorWithAlphaComponent(0.6)
        infoView.layer.cornerRadius = 10
        infoView.clipsToBounds = true
        infoView.textColor = UIColor.MKWhiteColor()
        infoView.textAlignment = NSTextAlignment.Center
        infoView.text = "Saving"
        infoView.alpha = 0.0
        infoView.center = self.view.center
        self.view.addSubview(infoView)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            infoView.alpha = 1.0
            }) { (finished) -> Void in
                if (finished) {
                    UIView.animateWithDuration(0.2, delay: 0.5, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                        infoView.alpha = 0.0
                        }, completion: { (finished) -> Void in
                            if finished {
                                infoView.removeFromSuperview()
                            }
                    })
                }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if currentProject?.name == "" {
            self.saveToolButtonTouched(nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func addImage(sender:UIButton) -> Void {
        var newImg = MKImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 100, height: 100)))
        newImg.controller = self
        newImg.delegate = self
        newImg.project = currentProject
        var center = self.view.center
        newImg.center = center
        newImg.viewDelegate = self
        self.currentView.insertSubview(newImg, belowSubview: self.projectTools)
        
    }
    
    func addInput(sender:UIButton) -> Void {
        var newInput = MKInput(frame: CGRect(origin: CGPointZero, size: CGSize(width: 100,height: 60)))
        newInput.controller = self
        newInput.viewDelegate = self
        newInput.project = currentProject
        var center = self.view.center
        newInput.center = center
        
        self.currentView.insertSubview(newInput, belowSubview: self.projectTools)
        
    }
    
    func addTableView(sender:UIButton) -> Void {
        var newInput = MKTableView(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width,height: 200)))
        newInput.controller = self
        newInput.viewDelegate = self
        newInput.project = currentProject
        var center = self.view.center
        newInput.center = center
        newInput.delegate = self
        self.currentView.insertSubview(newInput, belowSubview: self.projectTools)
    }
    
    func addCollectionView(sender:UIButton) -> Void {
        var newInput = MKCollectionView(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width,height: 200)))
        newInput.controller = self
        newInput.viewDelegate = self
        newInput.project = currentProject
        var center = self.view.center
        newInput.center = center
        newInput.delegate = self
        self.currentView.insertSubview(newInput, belowSubview: self.projectTools)
    }
    
    func addText(sender:UIButton) -> Void {
        var newText = MKText(frame: CGRect(origin: CGPointZero, size: CGSize(width: 100,height: 60)))
        newText.controller = self
        newText.viewDelegate = self
        newText.project = currentProject
        var center = self.view.center
        newText.center = center
        newText.delegate = self
        self.currentView.insertSubview(newText, belowSubview: self.projectTools)
        
    }
    
    func addButton(sender:UIButton) -> Void {
        var newButton = MKButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: 100,height: 60)))
        newButton.controller = self
        var center = self.view.center
        newButton.center = center
        newButton.viewDelegate = self
        newButton.project = currentProject
        self.currentView.insertSubview(newButton, belowSubview: self.projectTools)
    }
    
    func addLabel(sender:UIButton) -> Void {
        var newLabel = MKLabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: 100,height: 60)))
        newLabel.controller = self
        var center = self.view.center
        newLabel.center = center
        newLabel.viewDelegate = self
        newLabel.project = currentProject
        self.currentView.insertSubview(newLabel, belowSubview: self.projectTools)
    }
    
    func addView(sender:UIButton) -> Void {
        var newView = MKView(frame: CGRect(x: 0,y: 0,width: 100,height: 150))
        var center = self.view.center
        newView.center = center
        newView.controller = self
        newView.viewDelegate = self
        newView.project = currentProject
        self.currentView.insertSubview(newView, belowSubview: self.projectTools)
    }
    
    func addSearchBar(sender: UIButton) -> Void {
        var newSearch = MKSearchBar(frame: CGRect(origin: CGPointZero, size: CGSize(width: 100,height: 60)))
        var center = self.view.center
        newSearch.center = center
        newSearch.controller = self
        newSearch.viewDelegate = self
        newSearch.project = currentProject
        self.currentView.insertSubview(newSearch, belowSubview: self.projectTools)
    }
    
    func selectMKView(view: MKView) {
        if self.selectedView != view {
            if let selectedV = self.selectedView {
                selectedV.border(UIColor.clearColor(), width: 0.0)
            }
            self.selectedView = view
            self.buttonTools.close({ () -> Void in
                self.buttonTools.addHorizontalButton(view.customisationAction)
                self.buttonTools.openOtherOrientation()
            }, sender : nil)
        }
        else {
            self.buttonTools.openOtherOrientation()
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.projectRootView.contentSize = CGSize(width: self.projectRootView.contentSize.height, height: self.projectRootView.contentSize.width)
    }
    
    func removeView(view: MKView) {
        var index = find(self.currentProject!.views, view)
        var k = self.currentProject!.views
        if let i = index {
            self.currentProject!.views.removeAtIndex(i)
        }
        k.removeAll(keepCapacity: false)
        view.removeFromSuperview()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            var imgV = self.view.viewWithTag(picker.view.tag) as! MKImageView
            var t = info[UIImagePickerControllerOriginalImage] as! UIImage
            imgV.setImage(t)
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var mktable = tableView.superview as! MKTableView
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        }
        cell!.imageView!.image = UIImage(named: "imageIcon")
        cell!.backgroundColor = UIColor.clearColor()
        cell!.textLabel!.text = mktable.cellTitle
        cell!.detailTextLabel!.text = mktable.cellDetail
        return cell!
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as? MKCollectionViewCell
        if cell == nil {
            cell = MKCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        }
        cell!.title.text = "title \(indexPath.row)"
        cell!.border(UIColor.MKBrownColor(), width: 2)
        return cell!
        
    }
    
}

