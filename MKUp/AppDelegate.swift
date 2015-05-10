//
//  AppDelegate.swift
//  MKUp
//
//  Created by Alexandre barbier on 08/10/14.
//  Copyright (c) 2014 Alexandre barbier. All rights reserved.
//

import UIKit
import ABCrashLog

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var url : NSURL?
    var window: UIWindow?
    var crashLogger = ABCrashLogger
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    //    MKUpConnections.ping("launch", info: "app MKUp launched", user:["id":"554e6a45ff3333dc1287a43c"], completion:nil)
      MKTeam.listTeams { (success, teams) -> Void in
        println(teams)
        }
//        MKUser.get("554e6a45ff3333dc1287a43c", completion: { (success, user, error) -> Void in
//            if success {
//            println(user)
//                user!.getTeam({ (success, users, error) -> Void in
//                    println(users)
//                })
//            }
//
//        
//            
//        })
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if (url.path != nil && url.path?.pathExtension == "mkup") {
            var t = MKProject.loadProject(url)
            var vc = self.window?.rootViewController as! ViewController
            vc.loadProject(t!)
        }
        return true
    }
    
    func applicationWillTerminate(application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


}

