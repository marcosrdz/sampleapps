//
//  LazyData.swift
//  Lazy Data
//
//  Created by Marcos Rodriguez on 3/13/16.
//  Copyright © 2016 Marcos Rodriguez Vélez. All rights reserved.
//

import Foundation
import CoreData

public class LazyData: NSObject {
    
    public enum LazyDataStoreType: Int {
        case Persistent = 0, Temporary
    }
    
    // MARK: - Singleton
    /*This is the instance, of LazyData, that will be used all the time. */
    public static let sharedInstance: LazyData = LazyData()
    private var dataModelName: String?
    private var storeType: LazyDataStoreType = .Persistent
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(LazyData.sharedInstance.dataModelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    public class func configure(dataModelName dataModelName: String? = nil, storeType: LazyDataStoreType) {
        /* Reset the managed object context if the passed storeType is temporary, or if it previously was persistent, but it'll now change to temporary. */
        if storeType == .Temporary || (LazyData.sharedInstance.storeType == .Persistent && storeType == .Temporary) {
            LazyData.reset()
            LazyData.save()
        }
        
        
        /* If there is no dataModelName passed, I will try to find for one and use it. */
        if let dataModelName = dataModelName {
            LazyData.sharedInstance.dataModelName = dataModelName
        }
        else {
            let filePath = NSBundle.mainBundle().pathsForResourcesOfType("momd", inDirectory: nil) as [NSString]
            LazyData.sharedInstance.dataModelName = filePath.last?.lastPathComponent
        }
        
        LazyData.sharedInstance.storeType = storeType
    }
    
    // MARK: - Core Data Boilerplate Code
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: LazyData.sharedInstance.managedObjectModel)
        
        let persistentStoreURL = LazyData.sharedInstance.applicationDocumentsDirectory.URLByAppendingPathComponent("\(LazyData.sharedInstance.dataModelName).sqlite")
        
        do {
            switch LazyData.sharedInstance.storeType {
            case .Persistent:
                do {
                    try coordinator.addPersistentStoreWithType(NSSQLiteStoreType,
                                                               configuration: nil,
                                                               URL: persistentStoreURL,
                                                               options: [NSMigratePersistentStoresAutomaticallyOption: true,
                                                                NSInferMappingModelAutomaticallyOption: true])
                }
            case .Temporary:
                try coordinator.addPersistentStoreWithType(NSInMemoryStoreType,
                                                           configuration: nil,
                                                           URL: nil,
                                                           options: [NSMigratePersistentStoresAutomaticallyOption: true,
                                                            NSInferMappingModelAutomaticallyOption: true])
            }
        }
        catch {
            fatalError("Persistent store error! \(error)")
        }
        
        return coordinator
    }()
    
    
    // MARK: - Managed Object Contexts
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = LazyData.sharedInstance.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.parentContext = LazyData.sharedInstance.privateManagedObjectContext
        return managedObjectContext
    }()
    
    // MARK: - Core Data Save
    public class func save() {
        guard LazyData.sharedInstance.managedObjectContext.hasChanges || LazyData.sharedInstance.privateManagedObjectContext.hasChanges else {
            return
        }
        
        LazyData.sharedInstance.managedObjectContext.performBlockAndWait() {
            do {
                try LazyData.sharedInstance.managedObjectContext.save()
            } catch {
                fatalError("Error saving main managed object context! \(error)")
            }
        }
        
        LazyData.sharedInstance.privateManagedObjectContext.performBlock() {
            do {
                try LazyData.sharedInstance.privateManagedObjectContext.save()
            } catch {
                fatalError("Error saving private managed object context! \(error)")
            }
        }
        
        LazyData.sharedInstance.managedObjectContext.performBlockAndWait { () -> Void in
            
        }
        
    }
    
    // MARK: - Fetch All Entities
    
    public class func allEntities() -> [NSEntityDescription]? {
        return LazyData.sharedInstance.managedObjectModel.entities
    }
    
}