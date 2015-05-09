//
//  MKImageView.swift
//  MKUp
//
//  Created by Alexandre barbier on 02/10/14.
//  Copyright (c) 2014 Alexandre barbier. All rights reserved.
//

import UIKit
import Foundation
import AssetsLibrary

class MKImageView: MKView {
    
    var imageV = UIImageView()
    var pickerView = UIImagePickerController()
    var delegate : protocol <UIImagePickerControllerDelegate, UINavigationControllerDelegate>?
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.imageV = self.getMainSubview()!
        if self.imageV.image == nil {
            self.imageV.image = UIImage(named: "imageIcon")
        }
        self.longPressActions.append(UIAlertAction(title: "Library",
                                                   style: UIAlertActionStyle.Default,
                                                 handler: { (alertAction) -> Void in
            self.pickerView.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.pickerView.delegate = self.delegate
            self.pickerView.view.tag = self.tag
            self.controller?.presentViewController(self.pickerView, animated: true, completion: nil)
        }))
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageV.frame = self.bounds
        self.imageV.image = UIImage(named: "imageIcon")
        self.clipsToBounds = true
        imageV.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.addSubview(imageV)
        
        self.longPressActions.append(UIAlertAction(title: "Library",
                                                   style: UIAlertActionStyle.Default,
                                                 handler: { (alertAction) -> Void in
            self.pickerView.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.pickerView.delegate = self.delegate
            self.pickerView.view.tag = self.tag
            self.controller?.presentViewController(self.pickerView, animated: true, completion: nil)
        }))
    }
    
    
    func setImage(image:UIImage?) {
        imageV.image = image
    }
}
