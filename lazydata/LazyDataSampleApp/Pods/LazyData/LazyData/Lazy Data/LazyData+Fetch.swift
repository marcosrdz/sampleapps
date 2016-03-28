//
//  LazyData+Fetch.swift
//  Lazy Data
//
//  Created by Marcos Rodriguez on 3/13/16.
//  Copyright © 2016 Marcos Rodriguez Vélez. All rights reserved.
//

import Foundation
import CoreData

extension LazyData {

    public class func fetchObjects(entityName entityName: String, predicate: NSPredicate? = nil, sortBy: [NSSortDescriptor]? = nil, limit: Int = 0) -> [AnyObject]? {
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortBy
        fetchRequest.fetchLimit = limit
        
        do {
            return try LazyData.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest)
        }
        catch {
            print("Lazy Data Error: Error occured while executing fetchRequest")
        }
        return nil
    }
    
}