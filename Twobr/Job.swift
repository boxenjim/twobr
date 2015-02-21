//
//  Job.swift
//  Twobr
//
//  Created by Jim Schultz on 2/20/15.
//  Copyright (c) 2015 Blue Boxen, LLC. All rights reserved.
//

import Foundation
import CoreData

class Job: NSManagedObject {

    @NSManaged var created_at: String
    @NSManaged var id_str: String
    @NSManaged var text: String
    @NSManaged var user: User
    
    class func job() -> Job {
        return NSEntityDescription.insertNewObjectForEntityForName("Job", inManagedObjectContext: TwobrDataModel.sharedStore.managedObjectContext!) as Job
    }
    
    class func job(params: [String:AnyObject]) -> Job {
        var job = Job()
        job.update(params)
        return job
    }

    func update(params: Dictionary<String, AnyObject>) {
        for key in params.keys {
            if let value: AnyObject = params[key] {
                setValue(value, forKey: key)
            }
        }
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "user" {
            
        } else {
            super.setValue(value, forKey: key)
        }
    }
}
