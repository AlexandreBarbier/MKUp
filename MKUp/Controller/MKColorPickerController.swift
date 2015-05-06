//
//  MKColorPickerController.swift
//  MKUp
//
//  Created by Alexandre barbier on 03/10/14.
//  Copyright (c) 2014 Alexandre barbier. All rights reserved.
//

import UIKit

protocol MKColorPickerDelegate {
    func colorPickerChooseColor(colorPicker:MKColorPickerController, color:UIColor)
}

class MKColorPickerController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var redGradientView: UIView!
    @IBOutlet weak var greenGradientView: UIView!
    @IBOutlet weak var blueGradientView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var colorPreview: UIView!
    @IBOutlet weak var redSelector: UIView!
    @IBOutlet weak var greenSelector: UIView!
    @IBOutlet weak var blueSelector: UIView!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!
    @IBOutlet weak var redTextField: UITextField!
    
    var red : CGFloat = 0
    var green : CGFloat = 0
    var blue : CGFloat = 0
    var delegate : MKColorPickerDelegate?
    
    var currentColor : UIColor? = UIColor.whiteColor() {
        didSet {
            if let cur = currentColor {
                
            }
            else {
                currentColor = UIColor.whiteColor()
            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.rounded(5.0)
        self.backView.rounded(4.0)
        redTextField.userInteractionEnabled = false
        greenTextField.userInteractionEnabled = false
        blueTextField.userInteractionEnabled = false
        var redGradient = CAGradientLayer(layer: redGradientView.layer)
        redGradient.frame = CGRect(x: 0,y: 0,width: redGradientView.frame.size.width,height: redGradientView.frame.size.height)
        redGradient.colors = [UIColor.blackColor().CGColor, UIColor.redColor().CGColor]
        redGradient.startPoint = CGPoint(x: 0.0,y: 0.5)
        redGradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        redGradientView.layer.insertSublayer(redGradient, atIndex: 0)
        
        var greenGradient = CAGradientLayer(layer: greenGradientView.layer)
        greenGradient.frame = CGRect(x: 0,y: 0,width: greenGradientView.frame.size.width,height: greenGradientView.frame.size.height)
        greenGradient.colors = [UIColor.blackColor().CGColor, UIColor.greenColor().CGColor]
        greenGradient.startPoint = CGPoint(x: 0.0,y: 0.5)
        greenGradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        greenGradientView.layer.insertSublayer(greenGradient, atIndex: 0)
        
        var blueGradient = CAGradientLayer(layer: blueGradientView.layer)
        blueGradient.frame = CGRect(x: 0,y: 0,width: blueGradientView.frame.size.width,height: blueGradientView.frame.size.height)
        blueGradient.colors = [UIColor.blackColor().CGColor, UIColor.blueColor().CGColor]
        blueGradient.startPoint = CGPoint(x: 0.0,y: 0.5)
        blueGradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        blueGradientView.layer.insertSublayer(blueGradient, atIndex: 0)
        
        var redGesture = UIPanGestureRecognizer(target: self, action: "moveSelector:")
        self.redGradientView.addGestureRecognizer(redGesture)
        var greenGesture = UIPanGestureRecognizer(target: self, action: "moveSelector:")
        self.greenGradientView.addGestureRecognizer(greenGesture)
        var blueGesture = UIPanGestureRecognizer(target: self, action: "moveSelector:")
        self.blueGradientView.addGestureRecognizer(blueGesture)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.alpha = 1.0
            }) { (finished) -> Void in
        }
        if let col = currentColor {
            col.getRed(&red, green: &green, blue: &blue, alpha: nil)
            
            let redX = (red * self.redGradientView.frame.width)
            self.redSelector.center = CGPoint(x:redX, y: self.redSelector.center.y)
            
            let greenX = (green * self.redGradientView.frame.width)
            self.greenSelector.center = CGPoint(x:greenX, y: self.greenSelector.center.y)
            
            let blueX = (blue * self.redGradientView.frame.width)
            self.blueSelector.center = CGPoint(x:blueX, y: self.blueSelector.center.y)
            self.colorPreview.backgroundColor = col
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.alpha = 0.0;
    }
    @IBAction func doneTouched(sender: AnyObject) {
    
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.alpha = 0.0
        }) { (finished) -> Void in
            if finished {
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            }
        }
    
    }
    
    func moveSelector(sender:UIPanGestureRecognizer) {
        var point = sender.locationInView(sender.view)
        var value = CGFloat(255.0)
        var pointValue = (point.x / self.redGradientView.frame.size.width ) * 255.0
        switch sender.view! {
        case self.redGradientView :
            
            if (pointValue <= 255 && pointValue > 0) {
                self.redSelector.center = CGPoint(x:point.x, y: self.redSelector.center.y)
                value = (self.redSelector.center.x / self.redGradientView.frame.size.width) * 255.0
            }
            else if (pointValue <= 0){
                self.redSelector.center = CGPoint(x:0, y: self.redSelector.center.y)
                value = 0
            }
            else {
                self.redSelector.center = CGPoint(x:self.redGradientView.frame.width, y: self.redSelector.center.y)
            }
            self.red = value / 255
            self.redTextField.text = "\(Int(value))"
        case self.greenGradientView :
            
            if (pointValue <= 255 && pointValue > 0) {
                self.greenSelector.center = CGPoint(x:point.x, y: self.greenSelector.center.y)
                value = (self.greenSelector.center.x / self.greenGradientView.frame.size.width ) * 255.0
            }
            else if (pointValue <= 0){
                self.greenSelector.center = CGPoint(x:0, y: self.greenSelector.center.y)
                                value = 0
            }
            else {
                self.greenSelector.center = CGPoint(x:self.greenGradientView.frame.width, y: self.greenSelector.center.y)
            }
            self.green = value / 255
            self.greenTextField.text = "\(Int(value))"
        case self.blueGradientView :
            
            if (pointValue <= 255 && pointValue > 0) {
                self.blueSelector.center = CGPoint(x:point.x, y: self.blueSelector.center.y)
                value = (self.blueSelector.center.x / self.blueGradientView.frame.size.width ) * 255.0
            }
            else if (pointValue <= 0){
                self.blueSelector.center = CGPoint(x:0, y: self.blueSelector.center.y)
                                value = 0
            }
            else {
                self.blueSelector.center = CGPoint(x:self.blueGradientView.frame.width, y: self.blueSelector.center.y)
            }
            self.blue = value / 255
            self.blueTextField.text = "\(Int(value))"
        default:
            return
        }
        
        if self.delegate != nil {
            self.colorPreview.backgroundColor = UIColor(red: self.red, green: self.green, blue: self.blue, alpha: 1.0)
            self.delegate!.colorPickerChooseColor(self, color: self.colorPreview.backgroundColor!)
        }
    }
    
    
}
