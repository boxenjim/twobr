//
//  User.swift
//  Twobr
//
//  Created by Jim Schultz on 2/20/15.
//  Copyright (c) 2015 Blue Boxen, LLC. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var id_str: String
    @NSManaged var location: String
    @NSManaged var info: String
    @NSManaged var name: String
    @NSManaged var screen_name: String
    @NSManaged var profile_image_url: String
    @NSManaged var job: Job

    class func user() -> User {
        return NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: TwobrDataModel.sharedStore.managedObjectContext!) as User
    }
    
    class func user(params: [String:AnyObject]) -> User {
        if let usr = TwobrDataModel.sharedStore.findUser(params["id_str"] as String) as User? {
            usr.update(params)
            return usr
        }
        
        var user = User()
        user.update(params)
        return user
    }
    
//    class func user(params: [String:AnyObject], job: Job) -> User {
//        if let usr = TwobrDataModel.sharedStore.findUser(params["id_str"] as String) as User? {
//            
//        } else {
//            
//        }
//        var user = User()
//        user.job = job
//        user.update(params)
//        return user
//    }
    
    func update(params: Dictionary<String, AnyObject>) {
        for key in params.keys {
            if let value: AnyObject = params[key] {
                setValue(value, forKey: key)
            }
        }
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "description" {
            info = value as String
        } else {
            super.setValue(value, forKey: key)
        }
    }
}
