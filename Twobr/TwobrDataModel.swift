//
//  TwobrDataModel.swift
//  Twobr
//
//  Created by Jim Schultz on 2/11/15.
//  Copyright (c) 2015 Blue Boxen, LLC. All rights reserved.
//

import UIKit
import Swifties
import CoreData

class TwobrDataModel: BasicDataModel {
    class var sharedStore: TwobrDataModel {
        struct Singleton {
            static let instance = TwobrDataModel()
        }
        return Singleton.instance
    }
    
    func findJob(jobID: String) -> Job? {
        let fetchRequest = NSFetchRequest(entityName: "Job")
        fetchRequest.predicate = NSPredicate(format: "id_str MATCHES %@", jobID)
        
        var error: NSError? = nil
        let array = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error)
        return array?.last as? Job
    }
    
    func findUser(userID: String) -> User? {
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id_str MATCHES %@", userID)
        
        var error: NSError? = nil
        let array = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error)
        return array?.last as? User
    }
}
