//
//  MKView.swift
//  MKUp
//
//  Created by Alexandre barbier on 01/10/14.
//  Copyright (c) 2014 Alexandre barbier. All rights reserved.
//
import Foundation
import UIKit
var currentTag = 1

protocol MKViewDelegate {
    func selectMKView(view:MKView)
    func removeView(view:MKView)
}

class MKView: UIView, Printable, UIGestureRecognizerDelegate, MKColorPickerDelegate {
    
    var controller : UIViewController?
    var viewDelegate : MKViewDelegate?
    var shouldInteract = true
    var infoView = UIView(frame: CGRect(x:0,y:-52,width:100,height:44))
    var infoLabel = UILabel(frame: CGRect(x:8,y:8,width:84,height:36))
    var longPressActions : [UIAlertAction] = []
    var originFrame = CGRect()
    var cornerRad : Float = 0 {
        didSet {
            self.layer.cornerRadius = CGFloat(cornerRad)
        }
    }
    
    var alert = UIAlertController(title: "Actions", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
    var customisationAction : Dictionary<String, (sender:UIButton) -> Void> = Dictionary<String, (sender:UIButton) -> Void>()
    
    var project : MKProject? {
        didSet {
            if let proj = project {
                
            }
        }
    }
    
    override var description : String {
        get {
            return "\n--\n\(NSStringFromClass(self.dynamicType)) <\(self.frame)>\n--\n"
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.shouldInteract = aDecoder.decodeBoolForKey("shouldInteract")
        var corner = aDecoder.decodeFloatForKey("cornerRadius")
        self.project = aDecoder.decodeObjectForKey("project") as? MKProject
        self.cornerRad = corner
        self.layer.cornerRadius = CGFloat(cornerRad)
        self.infoLabel.backgroundColor = UIColor.MKGreyColor().colorWithAlphaComponent(0.3)
        self.infoLabel.layer.cornerRadius = 4.0
        self.infoLabel.numberOfLines = 0
        self.infoLabel.layer.masksToBounds = true
        self.infoLabel.font = UIFont.systemFontOfSize(10.0)
        self.infoView.addSubview(self.infoLabel)
        self.addSubview(infoView)
        self.infoView.hidden = true
        self.userInteractionEnabled = true
        var dragGesture = UIPanGestureRecognizer(target: self, action: "dragView:")
        if let window = UIApplication.sharedApplication().keyWindow {
            self.frame = UIApplication.sharedApplication().keyWindow!.bounds
        }
    
        var pinchGesture = UIPinchGestureRecognizer(target: self, action: "zoomView:")
        var tapGesture = UITapGestureRecognizer(target: self, action: "selectView:")
        tapGesture.numberOfTapsRequired = 1
        self.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin
        self.tag = currentTag++
        self.originFrame = self.frame
        var longTap = UILongPressGestureRecognizer(target: self, action: "longPress:")
        longTap.minimumPressDuration = 1
        
        if NSStringFromClass(self.dynamicType) != NSStringFromClass(MKView.self) {
            self.addGestureRecognizer(tapGesture)
            self.addGestureRecognizer(dragGesture)
            self.addGestureRecognizer(pinchGesture)
            self.addGestureRecognizer(longTap)
        }
        self.customisationAction.updateValue(backColor, forKey: "backColorIcon")
        self.customisationAction.updateValue(setSize, forKey: "resizeIcon")
        self.customisationAction.updateValue(cornerRadius, forKey: "radiusIcon")
        
        
        self.longPressActions.append(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
            
        }))
        self.longPressActions.append(UIAlertAction(title: "Remove element", style: UIAlertActionStyle.Destructive, handler: { (alertAction) -> Void in
            if let vDelegate = self.viewDelegate {
                vDelegate.removeView(self)
            }
        }))
        var t = UIAlertAction()
        self.longPressActions.append(UIAlertAction(title: "Fix element", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            self.shouldInteract = !self.shouldInteract
        }))
        
        self.longPressActions.append(UIAlertAction(title: "Bring to front", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            
            if let supView = self.superview {
                supView.bringSubviewToFront(self)
            }
        }))
        self.longPressActions.append(UIAlertAction(title: "Send back", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            if let supView = self.superview {
                supView.sendSubviewToBack(self)
            }
        }))
        
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeBool(self.shouldInteract, forKey: "shouldInteract")
        aCoder.encodeFloat(self.cornerRad, forKey: "cornerRadius")
        if let proj = self.project {
            aCoder.encodeObject(proj, forKey: "project")
        }
    }
    
    
    func getMainSubview<T>() -> T? {
        for subV in self.subviews as! [UIView] {
            if subV is T {
                return subV as? T
            }
        }
        return nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.infoLabel.backgroundColor = UIColor.MKGreyColor().colorWithAlphaComponent(0.3)
        self.infoLabel.layer.cornerRadius = 4.0
        self.infoLabel.numberOfLines = 0
        self.infoLabel.layer.masksToBounds = true
        self.infoLabel.font = UIFont.systemFontOfSize(10.0)
        self.infoView.addSubview(self.infoLabel)
        self.addSubview(infoView)
        self.infoView.hidden = true
        self.userInteractionEnabled = true
        var dragGesture = UIPanGestureRecognizer(target: self, action: "dragView:")
        var pinchGesture = UIPinchGestureRecognizer(target: self, action: "zoomView:")
        var tapGesture = UITapGestureRecognizer(target: self, action: "selectView:")
        tapGesture.numberOfTapsRequired = 1
        
        self.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin
        
        self.tag = currentTag++
        self.originFrame = self.frame
        var longTap = UILongPressGestureRecognizer(target: self, action: "longPress:")
        longTap.minimumPressDuration = 1
        
        if NSStringFromClass(self.dynamicType) != NSStringFromClass(MKView.self) {
            self.addGestureRecognizer(tapGesture)
            self.addGestureRecognizer(dragGesture)
            self.addGestureRecognizer(pinchGesture)
            self.addGestureRecognizer(longTap)
        }
        self.customisationAction.updateValue(backColor, forKey: "backColorIcon")
        self.customisationAction.updateValue(cornerRadius, forKey: "radiusIcon")
        self.customisationAction.updateValue(setSize, forKey: "resizeIcon")
        
        self.longPressActions.append(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
            
        }))
        self.longPressActions.append(UIAlertAction(title: "Remove element", style: UIAlertActionStyle.Destructive, handler: { (alertAction) -> Void in
            if let vDelegate = self.viewDelegate {
                vDelegate.removeView(self)
            }
        }))
        var t = UIAlertAction()
        self.longPressActions.append(UIAlertAction(title: "Fix element", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            
            self.shouldInteract = !self.shouldInteract
        }))
        self.longPressActions.append(UIAlertAction(title: "Bring to front", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            
            self.superview!.bringSubviewToFront(self)
        }))
        
        self.longPressActions.append(UIAlertAction(title: "Send back", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            
            self.superview!.sendSubviewToBack(self)
        }))
        
    }
    
    func addAction() -> Void {
        //implement:
    }
    
    func showHideStatusBar(sender:UIButton) -> Void {
        UIApplication.sharedApplication().setStatusBarHidden(!UIApplication.sharedApplication().statusBarHidden, withAnimation: UIStatusBarAnimation.Fade)
    }
    
    func backColor(sender:UIButton) -> Void {
        var t = MKColorPickerController(nibName: "MKColorPickerViewController", bundle: nil)
        t.delegate = self
        
        t.view.tag = 1500
        
        t.currentColor = self.backgroundColor
        if let controller = self.controller {
            t.view.center = controller.view.center
            controller.addChildViewController(t)
            controller.view.addSubview(t.view)
        }
        
    }
    
    func longPress(sender:UILongPressGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Began) {
            if alert.actions.count == 0 {
                for action : UIAlertAction in self.longPressActions {
                    alert.addAction(action)
                }
            }
            if let controller = self.controller {
                controller.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func setSize(sender:UIButton) -> Void {
        var alert = UIAlertController(title: "Customize", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        var setT = UIAlertAction(title: "Set Size", style: .Default, handler: { (_) -> Void in
            let width = alert.textFields![0] as! UITextField
            let height = alert.textFields![1] as! UITextField
            if width.text == "" || width.text == "0" {
                width.text = "\(self.frame.size.width)"
            }
            if height.text == "" || height.text == "0" {
                height.text = "\(self.frame.size.height)"
            }
            
            if ((width.text as NSString).floatValue != 0.0 && (height.text as NSString).floatValue != 0.0) {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.frame = CGRect(x: self.frame.origin.x,
                        y: self.frame.origin.y,
                        width: CGFloat((width.text as NSString).floatValue),
                        height: CGFloat((height.text as NSString).floatValue))
                })
                
            }
            
        })
        alert.addAction(setT)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            var infoT = NSString(format: "width : %.1f", Double(self.frame.size.width))
            textField.placeholder = "\(infoT)"
            textField.keyboardType = UIKeyboardType.DecimalPad
        })
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            var infoT = NSString(format: "height : %.1f", Double(self.frame.size.height))
            textField.placeholder = "\(infoT)"
            textField.keyboardType = UIKeyboardType.DecimalPad
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        if let controller = self.controller {
            controller.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func cornerRadius(sender:UIButton) -> Void {
        var alert = UIAlertController(title: "Customize", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        var setT = UIAlertAction(title: "Set Corner", style: .Default, handler: { (_) -> Void in
            let corner = alert.textFields![0] as! UITextField
            if corner.text == "" || corner.text == "0" {
                corner.text = "\(self.frame.size.width)"
            }
            
            if ((corner.text as NSString).floatValue != 0.0 ) {
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.cornerRad = (corner.text as NSString).floatValue
                    
                })
                
            }
            
        })
        alert.addAction(setT)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            
            textField.placeholder = "0"
            textField.keyboardType = UIKeyboardType.DecimalPad
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.controller?.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {

        if !gestureRecognizer.isKindOfClass(UILongPressGestureRecognizer) {
            return shouldInteract
        }
        
        return true
    }
    
    func selectView(sender:UITapGestureRecognizer) {
        if self.project!.isInPreview {
            self.superview!.endEditing(true)
            return
        }
        if viewDelegate != nil {
            self.border(UIColor.MKBrownColor(), width: 1.0)
            self.viewDelegate!.selectMKView(self)
        }
    }
    
    func zoomView(sender:UIPinchGestureRecognizer) {
        if self.project!.isInPreview {
            self.superview!.endEditing(true)
            return
        }
        var frame  = self.originFrame
        var scale = sender.scale
        var center = self.center
        
        frame.size.height = frame.height * scale
        frame.size.width = frame.width * scale
        
        
        if frame.width > self.superview!.frame.size.width {
            frame.size.width = self.superview!.frame.size.width
            
        }
        if frame.height > self.superview!.frame.size.height {
            frame.size.height = self.superview!.frame.size.height
        }
        if frame.origin.x < self.project!.rootView!.contentOffset.x {
            frame.origin.x = self.project!.rootView!.contentOffset.x
        }
        
        self.frame = frame
        self.center = center
        if sender.state == UIGestureRecognizerState.Ended {
            self.originFrame = self.frame
        }
    }
    
    func dragView(sender:UIPanGestureRecognizer) {
        if self.project!.isInPreview {
            self.superview!.endEditing(true)
            return
        }
        if let proj = self.project {
            var point = sender.locationInView(sender.view?.superview)
            if sender.state == UIGestureRecognizerState.Began {
                self.infoView.alpha = 0.0
                self.infoView.hidden = false
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.infoView.alpha = 1.0
                })
                for view : UIView in self.controller!.view.subviews as! [UIView] {
                    if view != self && view.alpha == 1.0 {
                        UIView.animateWithDuration(0.2, animations: { () -> Void in
                            view.alpha = 0.5
                        })
                    }
                }
            }
            if let controller = self.controller {
                if (abs(point.x - (self.superview!.center.x - self.project!.rootView!.contentOffset.x) ) < 10 ) {
                    point = CGPoint(x: self.superview!.center.x - self.project!.rootView!.contentOffset.x, y: point.y)
                }
                if (abs(point.y - self.superview!.center.y) < 10 ) {
                    point = CGPoint(x: point.x, y: self.superview!.center.y)
                }
                if (point.x - (self.frame.size.width / 2) < 0) {
                    point = CGPoint(x: (self.frame.size.width / 2), y: point.y)
                }
                if (point.x + (self.frame.size.width / 2) > self.superview!.frame.size.width) {
                    point = CGPoint(x: self.superview!.frame.size.width - (self.frame.size.width / 2), y: point.y)
                }
                if (point.y - (self.frame.size.height / 2) < 0) {
                    point = CGPoint(x: point.x, y: self.frame.size.height / 2)
                }
                if (point.y + (self.frame.size.height / 2) > self.superview!.frame.size.height) {
                    point = CGPoint(x: point.x, y: self.superview!.frame.size.height - (self.frame.size.height / 2))
                }
                if sender.state == UIGestureRecognizerState.Ended {
                    self.originFrame = self.frame
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.infoView.alpha = 0.0
                        }, completion: { (finished) -> Void in
                            if finished {
                                self.infoView.hidden = true
                            }
                    })
                    for view : UIView in controller.view.subviews as! [UIView] {
                        if view != self && view.alpha == 0.5 {
                            UIView.animateWithDuration(0.2, animations: { () -> Void in
                                view.alpha = 1
                            })
                        }
                    }
                }
            }
            var infoX = NSString(format: "%.1f", Double(point.x))
            var infoY = NSString(format: "%.1f", Double(point.y))
            
            self.infoLabel.text = " x : \(infoX)\n y : \(infoY)"
            self.center = point
        }
    }
    
    func colorPickerChooseColor(colorPicker:MKColorPickerController, color: UIColor) {
        self.backgroundColor = color
    }
    
    override func removeFromSuperview() {
        if self is MKTableView {
            var t = self as! MKTableView
            t.tableview.removeFromSuperview()
        }
        customisationAction.removeAll(keepCapacity: false)
        longPressActions.removeAll(keepCapacity: false)
        super.removeFromSuperview()
    }
    
    deinit {
        debugPrint("\(NSStringFromClass(self.dynamicType)) deinit")
    }

    
}
