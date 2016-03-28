//
//  LazyData+FetchedResultsController.swift
//  Lazy Data
//
//  Created by Marcos Rodriguez on 3/13/16.
//  Copyright © 2016 Marcos Rodriguez Vélez. All rights reserved.
//

import Foundation
import CoreData

extension LazyData {
    
    public class func fetchedResultsController(entityName entityName: String, predicate: NSPredicate? = nil, fetchLimit: Int? = nil, offset: Int? = nil, sortBy: [NSSortDescriptor]? = nil, separateSectionsByKey: String? = nil, cacheName: String? = nil) -> NSFetchedResultsController {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = predicate
        
        fetchRequest.sortDescriptors = sortBy ?? [NSSortDescriptor(key: "id", ascending: true)]

        if let fetchLimit = fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }
        
        if let offset = offset {
            fetchRequest.fetchOffset = offset
        }
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: LazyData.sharedInstance.managedObjectContext, sectionNameKeyPath: separateSectionsByKey, cacheName: cacheName)
        
        return fetchedResultsController
    }

}