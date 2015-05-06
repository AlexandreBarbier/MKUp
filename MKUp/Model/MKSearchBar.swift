//
//  MKSearchBar.swift
//  MKUp
//
//  Created by Alexandre barbier on 03/10/14.
//  Copyright (c) 2014 Alexandre barbier. All rights reserved.
//

import UIKit

class MKSearchBar: MKView {
    var searchBar = UISearchBar()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.searchBar = self.getMainSubview()!

    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.searchBar.frame = CGRect(x: 0,y: 0,width: self.frame.width, height: self.frame.height)
        self.searchBar.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.searchBar.userInteractionEnabled = false
        self.addSubview(self.searchBar)
    }
}
