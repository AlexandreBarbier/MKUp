//
//  ProjectDetailViewController.swift
//  MKUp
//
//  Created by Alexandre barbier on 22/11/14.
//  Copyright (c) 2014 Alexandre barbier. All rights reserved.
//

import UIKit
import ABUIKit

class ProjectDetailViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    var doc : UIDocumentInteractionController?
    var project : MKProject!
    var dataSource = [UIImage]()
    var completion : ((selectedIndex:Int) -> Void)!
    var selectedCells = [Int]()
    var edit = false
    var toolView = UIView()
    var editButton = UIButton()
    var closeButton = UIButton()
    var firstMovedIndex = -1
    var movingCell : ProjectViewCell?
    var firstCenter = CGPointZero
    var projectTools = ABExpendableButton(orientation: .Vertical, borderColor: UIColor.MKDarkBrownColor(), backColor: UIColor.MKWhiteColor())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        projectTools.verticaleDirection = .Up
        projectTools.addVerticalButton(["shareIcon": exportProject, "textIcon":addNote])
        projectTools.frame.origin = CGPoint(x: self.view.frame.width - projectTools.frame.width, y:self.view.frame.size.height - projectTools.frame.height)
        self.view.addSubview(projectTools)
        var header = UIView(frame: CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: 50))
        closeButton.frame = CGRect(x: self.view.frame.size.width - 58,y: 0, width: 50, height: 50)
        header.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        closeButton.setTitle("Close", forState: UIControlState.Normal)
        closeButton.addTarget(self, action: "closeView", forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.setTitleColor(UIColor.MKBrownColor(), forState: UIControlState.Normal)
        closeButton.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
        editButton.frame = CGRect(x:8,y: 0, width: 50, height: 50)
        editButton.setTitle("Edit", forState: UIControlState.Normal)
        editButton.addTarget(self, action: "editProject:", forControlEvents: UIControlEvents.TouchUpInside)
        editButton.setTitleColor(UIColor.MKBrownColor(), forState: UIControlState.Normal)
        editButton.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin
        var title = UILabel(frame: header.frame)
        title.text = "Projects"
        title.textAlignment = NSTextAlignment.Center
        title.textColor = UIColor.MKDarkBrownColor()
        title.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin
        header.backgroundColor = UIColor.MKGreenColor()
        header.addSubview(closeButton)
        header.addSubview(editButton)
        header.addSubview(title)
        toolView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 44)
        toolView.backgroundColor = UIColor.MKBrownColor()
        var delete = UIButton(frame: toolView.bounds)
        delete.setTitle("Delete", forState: UIControlState.Normal)
        delete.setTitleColor(UIColor.MKWhiteColor(), forState: UIControlState.Normal)
        delete.addTarget(self, action: "deleteViews", forControlEvents: UIControlEvents.TouchUpInside)
        toolView.addSubview(delete)
        self.view.addSubview(toolView)
        self.view.addSubview(header)
        self.collectionView!.backgroundColor = UIColor.MKGreyColor()
        self.collectionView!.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        self.collectionView!.showsHorizontalScrollIndicator = false
        self.collectionView!.showsVerticalScrollIndicator = false
        var moveCellGesture = UIPanGestureRecognizer(target: self, action: "moveCell:")
        moveCellGesture.delegate = self
        self.view.addGestureRecognizer(moveCellGesture)
    }
    
    func addNote(sender:UIButton) -> Void {
       var noteView = self.storyboard!.instantiateViewControllerWithIdentifier("NoteVC") as NotesViewController
        noteView.project = self.project
        self.presentViewController(noteView, animated: true, completion: nil)
    }
    
    func exportProject(sender: UIButton) {
        
        if let document = doc {
            document.URL = self.project!.getUrl()
            var b = doc!.presentOpenInMenuFromRect(CGRect(x: self.view.center.x, y: self.view.center.y, width: 320, height: 568), inView: self.view, animated: true)
            if !b {
                var alert = UIAlertView(title: "Error", message: "No application found to share your project", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
                alert.show()
            }
        }
        else {
            doc = UIDocumentInteractionController(URL: self.project!.getUrl())
            var b = doc!.presentOpenInMenuFromRect(CGRect(x: self.view.center.x, y: self.view.center.y, width: 320, height: 568), inView: self.view, animated: true)
            if !b {
                var alert = UIAlertView(title: "Error", message: "No application found to share your project", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
                alert.show()
            }
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKindOfClass(UIPanGestureRecognizer.self) {
            if !edit {
                return false
            }
        }
        return true
    }
    
    func moveCell(panGesture:UIPanGestureRecognizer) {
        let point = panGesture.locationInView(self.view)
        switch panGesture.state {
        case .Began :

            let index = self.collectionView!.indexPathForItemAtPoint(point)
            if let ind = index {
                movingCell = self.collectionView!.cellForItemAtIndexPath(ind) as? ProjectViewCell
                self.collectionView!.bringSubviewToFront(movingCell!)
                firstMovedIndex = ind.row
                firstCenter = movingCell!.center
            }
        case .Changed:
            if let movedCell = movingCell {
                let index = self.collectionView!.indexPathForItemAtPoint(point)
                if let ind = index {
                    var indexMoved = self.collectionView!.indexPathForCell(movedCell) as NSIndexPath!
                    self.collectionView!.moveItemAtIndexPath(indexMoved, toIndexPath: ind)
                    if firstMovedIndex != ind.row {
                        movedCell.center = self.collectionView!.cellForItemAtIndexPath(ind)!.center
                        self.firstCenter = movedCell.center
                    }
                    else {
                        movedCell.center = point
                    }
                }
                else {
                    movedCell.center = point
                }
            }
        case .Ended:
            if let movedCell = movingCell {
                let index = self.collectionView!.indexPathForItemAtPoint(point)
                if let ind = index {
                    var tmp = dataSource[firstMovedIndex]
                    dataSource.removeAtIndex(firstMovedIndex)
                    dataSource.insert(tmp, atIndex: ind.row)
                    var projView = self.project.views[firstMovedIndex]
                    self.project.views.removeAtIndex(firstMovedIndex)
                    self.project.views.insert(projView, atIndex: ind.row)
                    self.reorganiseProject()

                }
                else {
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        movedCell.center = self.firstCenter
                    }, completion: { (finished) -> Void in
                        
                    })
                }
                movedCell.setNeedsLayout()
               self.collectionView!.reloadData()
            }
        default :
            break
        }

    }
    
    func reorganiseProject() {
        for (var i = 0; i < self.project.views.count; i++) {
            var fr = self.project.views[0].bounds
            fr.origin.x += CGFloat(i) * fr.size.width
            self.project.views[i].frame = fr
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if dataSource.count == 0 {
        for rView in project.views {
            UIGraphicsBeginImageContext(rView.bounds.size)
            rView.layer.renderInContext(UIGraphicsGetCurrentContext())
            var image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            dataSource.append(image)
        }
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var item = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as ProjectViewCell
        item.imageView.image = dataSource[indexPath.row]
        return item
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (!edit) {
            completion(selectedIndex: indexPath.row)
            self.closeView()
        }
        else {
            
            var cell = collectionView.cellForItemAtIndexPath(indexPath) as ProjectViewCell
            var index = -1
            var counter = 0
            if selectedCells.count > 0 {
                
                for c : Int in selectedCells {
                    if indexPath.row == c {
                        index = counter
                        break
                    }
                    counter++           
                }
            }
            if index == -1 {
                cell.border(UIColor.MKDarkBrownColor(), width: 2)
                self.selectedCells.append(indexPath.row)
            }
            else {
                cell.border(UIColor.MKDarkBrownColor(), width: 0.0)
                self.selectedCells.removeAtIndex(index)
            }
            if selectedCells.count > 0  && CGAffineTransformIsIdentity(self.toolView.transform) {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.toolView.transform = CGAffineTransformMakeTranslation(0, -self.toolView.frame.height)
                })
            }
            else if (selectedCells.count == 0) {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.toolView.transform = CGAffineTransformIdentity
                })
            }
        }
    }
    
    func editProject(sender:UIButton) -> Void {
        edit = !edit
        if (edit) {
            sender.setTitle("Save", forState: UIControlState.Normal)
            self.closeButton.hidden = true
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.collectionView!.backgroundColor = UIColor.MKGreenColor()
            })
        }
        else {
            sender.setTitle("Edit", forState: UIControlState.Normal)
            self.closeButton.hidden = false
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.collectionView!.backgroundColor = UIColor.MKGreyColor()
                self.toolView.transform = CGAffineTransformIdentity
            })

            self.project.nbView = dataSource.count
            self.project.save()
            if self.presentingViewController != nil {
                var pres = self.presentingViewController as ViewController
                pres.loadProject(self.project)
                for index in selectedCells {
                    var cell = collectionView!.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as ProjectViewCell
                    cell.border(UIColor.MKDarkBrownColor(), width: 0.0)
                }
            }
        }
    }
    
    func deleteViews() -> Void {
        var indexes = [NSIndexPath]()
        selectedCells.sort { (a, b) -> Bool in
            if a > b {
                return true
            }
            return false
        }
        for index in selectedCells {
            var cell = collectionView!.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as ProjectViewCell
            cell.border(UIColor.MKDarkBrownColor(), width: 0.0)
            indexes.append(NSIndexPath(forItem: index, inSection: 0))
            var v = self.project.views.removeAtIndex(index) as MKView
            v.removeFromSuperview()
            self.dataSource.removeAtIndex(index)
        }
        self.project.nbView = dataSource.count
        self.reorganiseProject()
        self.project.save()
        
        if self.presentingViewController != nil {
            var pres = self.presentingViewController as ViewController
            pres.loadProject(self.project)
        }
        self.collectionView!.deleteItemsAtIndexPaths(indexes)
        selectedCells.removeAll(keepCapacity: false)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.toolView.transform = CGAffineTransformIdentity
        })
    }
    func closeView() -> Void {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
}
