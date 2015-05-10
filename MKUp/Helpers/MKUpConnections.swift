//
//  MKUpConnections.swift
//  MKUp
//
//  Created by Alexandre barbier on 09/05/15.
//  Copyright (c) 2015 Alexandre barbier. All rights reserved.
//

import UIKit

let MKUpConnectionsQueue = NSOperationQueue()
let MKUpAPIURL = "http://62.210.238.47:1337/"

class MKUpConnections: NSObject {
    
    class func ping(event:String, info:String, user:Dictionary<String, AnyObject>, completion:((success:Bool, data:AnyObject)->Void)?) {
        post("ping", param: ["event":event,"info":info, "user":user], completion: completion)
    }
    
    class func get(endpoint:String, param: Dictionary<String, AnyObject>, completion:((success:Bool, data:AnyObject)->Void)?) {
        var urlEncodedParam = ""
        for (key:String, value) in param {
            if urlEncodedParam == "" {
               urlEncodedParam = "?"
            }
            else {
               urlEncodedParam += "&"
            }
           
                urlEncodedParam += "\(key)=\(value)"
            
        }
        var url = "\(MKUpAPIURL)\(endpoint)/\(urlEncodedParam)"
        var request = NSMutableURLRequest(URL: NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: MKUpConnectionsQueue) { (response, data, error) -> Void in
            if error == nil {
                completion?(success: true, data: data)
            }
            else {
                completion?(success: false, data: error)
            }
        }
    }
    
    class func post(endpoint:String, param: Dictionary<String, AnyObject>, completion:((success:Bool, data:AnyObject)->Void)?) {
        var url = "\(MKUpAPIURL)\(endpoint)/"
        var request = NSMutableURLRequest(URL: NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!)
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(param, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        request.HTTPMethod = "POST"
        
        request.setValue(String(request.HTTPBody!.length), forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: MKUpConnectionsQueue) { (response, data, error) -> Void in
            if error == nil {
                completion?(success: true, data: data)
            }
            else {
                completion?(success: false, data: error)
            }
        }
    }
    
    class func downloadFile(endpoint:String, param: Dictionary<String, NSData>, completion:((success:Bool, data:AnyObject)->Void)?) {
        var url = "\(MKUpAPIURL)\(endpoint)/"
        var request = NSMutableURLRequest(URL: NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!)
        
        get(endpoint, param: param) { (success, data) -> Void in
            
            if success {
                var file = data as! NSData
                var p = MKProject.loadProjectFromData(file)
            }
            else {
                
            }
        }
    }
    
    class func uploadFile(endpoint:String, param: Dictionary<String, NSData>, completion:((success:Bool, data:AnyObject)->Void)?) {
        var url = "\(MKUpAPIURL)\(endpoint)/"
        var request = NSMutableURLRequest(URL: NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!)

        
        request.HTTPMethod = "POST"
        var body = NSMutableData()
        var boundary = "0xKhTmLbOuNdArY"
        var contentType = "multipart/form-data; boundary=\(boundary)"
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
        body.appendData("Content-Disposition: form-data; name=\"project\"; filename=\"project\"\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
        body.appendData("Content-Type: application/octet-stream\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
        body.appendData(NSData(data:param["file"]!))
        body.appendData("\r\n--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
        
        request.HTTPBody = body
        request.setValue(String(request.HTTPBody!.length), forHTTPHeaderField: "Content-Length")
        NSURLConnection.sendAsynchronousRequest(request, queue: MKUpConnectionsQueue) { (response, data, error) -> Void in
            if error == nil {
                completion?(success: true, data: data)
            }
            else {
                completion?(success: false, data: error)
            }
        }
    }
    
    class func put(endpoint:String, param: Dictionary<String, AnyObject>, completion:((success:Bool, data:AnyObject)->Void)?) {
        var url = "\(MKUpAPIURL)\(endpoint)/"
        var request = NSMutableURLRequest(URL: NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!)
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(param, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        request.HTTPMethod = "PUT"
        
        request.setValue(String(request.HTTPBody!.length), forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: MKUpConnectionsQueue) { (response, data, error) -> Void in
            if error == nil {
                completion?(success: true, data: data)
            }
            else {
                completion?(success: false, data: error)
            }
        }
    }
}
