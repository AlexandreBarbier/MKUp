//
//  MKProject.swift
//  MKUp
//
//  Created by Alexandre barbier on 04/10/14.
//  Copyright (c) 2014 Alexandre barbier. All rights reserved.
//

import UIKit

var saveQueue = NSOperationQueue()

///
/// project class extend NSObject NSCoding and Printable
///

class MKProject : NSObject, NSCoding, Printable {
    /// project's views
    var views : [MKView] = []
    /// project's name
    var name : String = ""
    /// project's update date
    var update : NSDate = NSDate()
    /// project's creation date
    var creation : NSDate?
    /// project's physic URL
    var fileURL : NSURL?
    /// project's image preview
    var preview : UIImage?
    /// project's root view
    var rootView : UIScrollView?
    /// project's view number
    var nbView : Int = 1
    /// project's notes
    var notes : NSAttributedString?
    
    var isInPreview : Bool = false {
        didSet {
                for view in self.views {
                    for subv in view.subviews as! [UIView] {
                        if subv.isKindOfClass(MKCollectionView.self) {
                            var v = subv as! MKCollectionView
                            v.collectionView!.userInteractionEnabled = !v.collectionView!.userInteractionEnabled
                        }
                        else if subv.isKindOfClass(MKTableView.self) {
                            var v = subv as! MKTableView
                            v.tableview.userInteractionEnabled = !v.tableview.userInteractionEnabled
                        }
                        else if subv.isKindOfClass(MKButton.self) {
                            var v = subv as! MKButton
                            v.button.userInteractionEnabled = !v.button.userInteractionEnabled
                        }
                        else if subv.isKindOfClass(MKSearchBar.self) {
                            var v = subv as! MKSearchBar
                            v.searchBar.userInteractionEnabled = !v.searchBar.userInteractionEnabled
                        }
                        else  {
                            subv.userInteractionEnabled = !isInPreview
                        }
                        
                    }
                }
            }
    }

    override var description: String {
        get {
            return "\n--  MKProject --\n name : \(self.name)\n creation date : \(self.creation)\n update date : \(self.update)\n --\n"
        }
    }

    init (name:String) {
        super.init()
        self.name = name
        var firstView = MKView()
        firstView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        firstView.project = self
        
        self.views.append(firstView)
        self.creation = NSDate()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.views, forKey: "views")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.update, forKey: "update")
        aCoder.encodeInteger(self.nbView, forKey: "nbView")
        if let create = creation {
            aCoder.encodeObject(create, forKey: "creation")
        }
        if let file = fileURL {
            aCoder.encodeObject(file, forKey: "fileURL")
        }
        if let image = preview {
            aCoder.encodeObject(image, forKey: "preview")
        }
        if let note = self.notes {
            aCoder.encodeObject(note, forKey: "notes")
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        self.views = aDecoder.decodeObjectForKey("views") as! [MKView]
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.creation = aDecoder.decodeObjectForKey("creation") as? NSDate
        self.update = aDecoder.decodeObjectForKey("update") as! NSDate
        self.fileURL = aDecoder.decodeObjectForKey("fileURL") as? NSURL
        self.preview = aDecoder.decodeObjectForKey("preview") as? UIImage
        self.nbView = self.views.count
        self.notes = aDecoder.decodeObjectForKey("notes") as! NSAttributedString?
    }
    
    private class func getDirectoryPath() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var documentDirectory = paths[0] as! String
        var bundlePath = NSBundle.mainBundle().bundleIdentifier
        return "\(documentDirectory)/\(bundlePath!).projects"
    }
    /**
        save the project on disk
    */
    func save() {
        var error : NSError? = NSError()
        saveQueue.name = "Save"
        self.update = NSDate()
        let rView = self.views[0]        
        if let root = self.rootView {
            root.contentSize = CGSize(width: CGFloat(self.views.count) * rView.frame.width, height: rView.frame.height)
        }
        if rView.frame != CGRectZero {
            UIGraphicsBeginImageContext(rView.bounds.size);
            rView.layer.renderInContext(UIGraphicsGetCurrentContext())
            var image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.preview = image
        }
        var path = MKProject.getDirectoryPath()
        if self.name == "" {
            self.name = "project\(random() % 100000)"
        }
        saveQueue.addOperationWithBlock { () -> Void in
            NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil, error: &error)
            if NSFileManager.defaultManager().fileExistsAtPath("\(path)/\(self.name).mkup") {
                NSFileManager.defaultManager().removeItemAtPath("\(path)/\(self.name).mkup", error: nil)
            }
            NSKeyedArchiver.archiveRootObject(self, toFile: "\(path)/\(self.name).mkup")
            if let url = self.fileURL {
                NSKeyedArchiver.archiveRootObject(self, toFile: url.path!)
            }
        }
        
    }
    /**
    load project
    
    :param: name project's name
    
    :returns: the project or nil if the name was not found
    */
    class func load(name:String) -> MKProject? {
        var path = getDirectoryPath()
        var project = NSKeyedUnarchiver.unarchiveObjectWithFile("\(path)/\(name).mkup") as! MKProject?
        return project
    }
    /**
    load project
    
    :param: url project's url
    
    :returns: the project or nil if the url was not found
    */
    class func loadProject(url:NSURL) -> MKProject? {
        var project = NSKeyedUnarchiver.unarchiveObjectWithFile(url.path!) as! MKProject?
        project?.fileURL = url
        return project
    }
    
    class func loadProjectFromData(data:NSData) -> MKProject? {
        var project = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! MKProject?

        return project
    }
    
    func getUrl() -> NSURL {
        var path = MKProject.getDirectoryPath()
        var filePath = "\(path)/\(name).mkup"
        
        return NSURL(fileURLWithPath: filePath)!
    }
    
    class func getLastOpenedProject() -> MKProject? {
        var projects = listAllProject()
        var retProject : MKProject?
        
        if let allProject = projects {
            for project : MKProject in allProject {
                
                if (retProject == nil || retProject!.update.compare(project.update) == NSComparisonResult.OrderedAscending) {
                    retProject = project
                }
            }
        }
        if retProject == nil {
            retProject = MKProject(name: "")
        }
        return retProject
    }
    
    class func listAllProject() -> [MKProject]? {
        var path = getDirectoryPath()
        var error : NSError? = NSError()
        var k = NSFileManager.defaultManager().contentsOfDirectoryAtPath(path, error: &error)
        var projects : [MKProject]?
        if k != nil {
            for filename : String in k as! [String] {
                if projects == nil {
                    projects = []
                }
                projects?.append(self.load(filename.stringByDeletingPathExtension)!)
            }
        }
        return projects
    }
    
    func removeFromView() {
        for v : MKView in self.views {
            v.removeFromSuperview()
        }
        self.views.removeAll(keepCapacity: false)
    }
    
    class func deleteProject(name:String) -> Bool {
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var documentDirectory = paths[0] as! String
        var bundlePath = NSBundle.mainBundle().bundleIdentifier
        var path = "\(documentDirectory)/\(bundlePath!).projects/\(name).mkup"
        var error : NSError? = NSError()
        return NSFileManager.defaultManager().removeItemAtPath(path, error: &error)
    }
    
    deinit {
        debugPrint("deinit project \(self.name)")
    }
}