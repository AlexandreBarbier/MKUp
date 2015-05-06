//
//  MKText.swift
//  MKUp
//
//  Created by Alexandre barbier on 02/10/14.
//  Copyright (c) 2014 Alexandre barbier. All rights reserved.
//

import UIKit

class MKText: MKView, MKColorPickerDelegate {
    var textV = UITextView()
    var delegate : protocol <UITextViewDelegate>? {
        didSet {
            textV.delegate = self.delegate
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textV = self.getMainSubview()!

        self.customisationAction.updateValue(textColor, forKey: "textColorIcon")
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textV.frame = CGRect(x: 0,y: 0,width: frame.size.width,height: frame.size.height)
        textV.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        textV.backgroundColor = UIColor.clearColor()
        textV.scrollEnabled = false
        textV.text = "Lorem ipsum dolor sit amet, clita consetetur ei est. Mutat quodsi scriptorem an est, probatus deseruisse consetetur ea eam. Ne mutat saperet vim, cibo deleniti percipitur per ex, an mei eros elitr equidem. In eam erat paulo ornatus, te eum audire blandit ancillae. Ad simul dolore qui, has idque homero moderatius ad, menandri adipisci sea no. Porro honestatis ne has, eu iisque lucilius per. Pro te stet oporteat, viris luptatum in has. Pri at timeam ornatus. Elit quando partem ad nec. Ei oratio graece eum, pro ridens verear id, qui te brute dicant nusquam. Lorem efficiendi has cu, at sea doming delectus. Facete aliquando id ius, ea tale wisi noster usu. Qui at tale sonet alienum, eam te mollis temporibus. Liber nostro legendos ex vis, enim diceret qualisque et pri. Eam liber movet ut. Atomorum partiendo ne per, sale decore epicuri ut per. Mea essent repudiare ad, meis pertinax in nec. At his quem adversarium contentiones. Laudem lucilius cu cum. Ad vix prompta voluptatibus, dico feugiat mel ei. At pri cibo illud simul, solet torquatos repudiandae pro in, quo novum soluta docendi ut. Putent saperet in eam, esse errem officiis ne ius. Ut eum altera putant, tritani sapientem sea cu, ex clita salutandi sed. No mei dolor impedit, mel quando voluptua ea. Ad vero decore vim, malis meliore facilisis mel et, cu cum solum erroribus vituperatoribus."
        textV.userInteractionEnabled = false
        textV.textColor = UIColor.blackColor()
        self.addSubview(textV)
        self.customisationAction.updateValue(textColor, forKey: "textColorIcon")
        
    }
    
    override func colorPickerChooseColor(colorPicker:MKColorPickerController, color: UIColor) {
        if colorPicker.view.tag == 1500 {
            super.colorPickerChooseColor(colorPicker, color: color)
        }
        else {
            self.textV.textColor = color
        }
    }
    
    func textColor(sender:UIButton)-> Void {
        
        var t = MKColorPickerController(nibName: "MKColorPickerViewController", bundle: nil)
        t.delegate = self
        if let controller = self.controller {
            controller.addChildViewController(t)
            t.view.center = controller.view.center
            controller.view.addSubview(t.view)
        }
        t.currentColor = self.textV.textColor
    }
    
    
    
}
