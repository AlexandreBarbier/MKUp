//
//  MKProj.swift
//  MKUp
//
//  Created by Alexandre barbier on 10/05/15.
//  Copyright (c) 2015 Alexandre barbier. All rights reserved.
//

import UIKit

class MKProj: NSObject {
    var team:String = ""
    var name : String = ""
    var url : String = ""
    var file : String = ""
    
    class func create(name:String) {
        MKUpConnections.post("projects", param: ["name":name]) { (success, data) -> Void in
            if success {
                var dta = data as! NSData
            }
        }
    }
    
    class func download(projectId:String, completion:(success:Bool, project:MKProject?) -> Void) {
        MKUpConnections.downloadFile("projects/\(projectId)/download", param: [:]) { (success, data) -> Void in
            if (success) {
                var file = data as! NSData
                var p = MKProject.loadProjectFromData(file)
                completion(success: true, project: p)
            }
            else {
                completion(success: false, project: nil)
            }
        }
    }
    
    class func upload(projectId:String, file:NSData) {
        MKUpConnections.uploadFile("projects/\(projectId)/download", param: ["file":file]) { (success, data) -> Void in
            
        }
    }
    
    class func listTeamProject() {
        let teamId = "554f8ac5869385e737c0750c"
        MKUpConnections.get("projects/team/\(teamId)", param: [:]) { (success, data) -> Void in
            
        }
    }
}
