//
//  LazyData+Delete.swift
//  Lazy Data
//
//  Created by Marcos Rodriguez on 3/13/16.
//  Copyright © 2016 Marcos Rodriguez Vélez. All rights reserved.
//

import Foundation
import CoreData

extension LazyData {
    
    // MARK: - Delete all objects in Managed Context.
    public class func deleteAllObjects() {
        if let entities = LazyData.allEntities() {
            for entity in entities {
                if let entityName = entity.name {
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: entityName))
                    do {
                        try LazyData.sharedInstance.managedObjectContext.executeRequest(deleteRequest)
                    }
                    catch {
                        print("LAZYDATA ERROR DELETING ALL OBJECTS: \(error)")
                    }
                }
            }
        }
    }
    
    // MARK: - Delete the passed object from the Managed Context
    public class func deleteObject(object: NSManagedObject) {
        LazyData.sharedInstance.managedObjectContext.deleteObject(object)
        LazyData.save()
    }
    
    // MARK: - Reset the Managed Context.
    public class func reset() {
        LazyData.sharedInstance.managedObjectContext.reset()
    }
    
}