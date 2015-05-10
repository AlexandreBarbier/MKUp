//
//  MKUser.swift
//  MKUp
//
//  Created by Alexandre barbier on 10/05/15.
//  Copyright (c) 2015 Alexandre barbier. All rights reserved.
//

import UIKit
import ABModel

class MKUser: ABModel {
    var username        :String = ""
    var firstname   :String = ""
    var id   :String = ""
    var team        :MKTeam = MKTeam()
    
    override var description :String {
        get
        {
            return "\nMKUser :\n\tid:\(id)\n\tusername: \(username)\n\tfirstname:\(firstname)\n\tteam:\(team)\n\n"
        }
    }
    
    class func get(userId:String, completion:(success:Bool, user:MKUser?, error:AnyObject?) -> Void) {
        MKUpConnections.get("users/\(userId)", param: [:]) { (success, data) -> Void in
            if success {
                var response = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves, error: nil) as? Dictionary<String, AnyObject>
                var us = MKUser(dictionary: response!["response"]! as! Dictionary<String, AnyObject>)
                completion(success: success, user: us, error: nil)
            }
        }
    }
    
    func getTeam(completion:(success:Bool, user:[MKUser]?, error:AnyObject?)->Void) {
        MKUpConnections.get("users/\(self.id)/team", param: [:]) { (success, data) -> Void in
            if success {
                var response = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves, error: nil) as? Dictionary<String, AnyObject>
                var us = MKTeam(dictionary: response!["response"]! as! Dictionary<String, AnyObject>)
                completion(success: success, user: us.users, error: nil)
            }
        }
    }
    
}
