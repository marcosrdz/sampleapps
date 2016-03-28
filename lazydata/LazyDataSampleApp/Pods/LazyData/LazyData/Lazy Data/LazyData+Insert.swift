//
//  LazyData+Insert.swift
//  Lazy Data
//
//  Created by Marcos Rodriguez on 3/13/16.
//  Copyright © 2016 Marcos Rodriguez Vélez. All rights reserved.
//

import Foundation
import CoreData

extension LazyData {

    public class func insertObject(entityName entityName: String, dictionary: [String: AnyObject]) {
        let entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: LazyData.sharedInstance.managedObjectContext)
        
        for (key, value) in dictionary {
            let object = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: LazyData.sharedInstance.managedObjectContext)
            object.willAccessValueForKey(key)
            object.willChangeValueForKey(key)
            object.setValue(value, forKeyPath: key)
            object.didChangeValueForKey(key)
            LazyData.sharedInstance.managedObjectContext.insertObject(object)
        }
        LazyData.save()
    }
    
}