//
//  MKUser.swift
//  MKUp
//
//  Created by Alexandre barbier on 10/05/15.
//  Copyright (c) 2015 Alexandre barbier. All rights reserved.
//

import UIKit
import ABModel
import ABUIKit

class MKUser: ABModel {
    var username    :String = ""
    var firstname   :String = ""
    var id          :String = ""
    var team        :String = ""
    
    override var description :String {
        get
        {
            return "\nMKUser :\n\tid:\(id)\n\tusername: \(username)\n\tfirstname:\(firstname)\n\tteam:\(team)\n\n"
        }
    }
    
    class func create(username:String, firstname:String) {
        MKUpConnections.post("user", param:["username":username, "firstname":firstname]) { (success, data) -> Void in
            
        }
    }
    
    func addToTeam(teamId:String) {
        MKUpConnections.put("user/\(self.id)", param: ["team":teamId]) { (success, data) -> Void in
            
        }
    }
    
    class func get(userId:String, completion:(success:Bool, user:MKUser?, error:AnyObject?) -> Void) {
        MKUpConnections.get("users/\(userId)", param: [:]) { (success, data) -> Void in
            if success {
                var response = data!.toJSON() 
                var us = MKUser(dictionary: response["response"]! as! Dictionary<String, AnyObject>)
                completion(success: success, user: us, error: nil)
            }
        }
    }
    
    func getTeam(completion:(success:Bool, users:[MKUser]?, error:AnyObject?)->Void) {
        MKUpConnections.get("users/\(self.id)/team", param: [:]) { (success, data) -> Void in
            if success {
                var response = data!.toJSON()
                var us = MKTeam(dictionary: response["response"]! as! Dictionary<String, AnyObject>)
                completion(success: success, users: us.users, error: nil)
            }
        }
    }
    
}
