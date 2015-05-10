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
    var users = [MKUser()]
    override var description :String {
        get
        {
            return "\nMKTeam :\n\tid:\(id)\n\tusername: \(name)\n\tusers:\(users) \n\n"
        }
    }
    
    class func listTeams(completion:(success:Bool, teams:[MKTeam]?)->Void) {
        MKUpConnections.get("teams", param: [:]) { (success, data) -> Void in
            if success {
                var response = data!.toJSON()
                var allTeams = [MKTeam]()
                for dico:Dictionary<String, AnyObject> in  response["response"] as! [Dictionary<String, AnyObject>] {
                    allTeams.append(MKTeam(dictionary: dico))
                }

                completion(success: success, teams: allTeams)
            }
        }
        
    }
}
