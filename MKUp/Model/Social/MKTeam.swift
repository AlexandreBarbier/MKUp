//
//  MKTeam.swift
//  MKUp
//
//  Created by Alexandre barbier on 10/05/15.
//  Copyright (c) 2015 Alexandre barbier. All rights reserved.
//

import UIKit
import ABModel

class MKTeam: ABModel {
    var name:String = ""
    var id:String = ""
    var users:[MKUser] = [MKUser]()
    override var description :String {
        get
        {
            return "\nMKTeam :\n\tid:\(id)\n\tusername: \(name)\n\tusers:\(users) \n\n"
        }
    }
    required override init() {
        super.init()
    }
    
    required init(dictionary: Dictionary<String, AnyObject>) {
        super.init(dictionary: dictionary)
        
    }
    
}
