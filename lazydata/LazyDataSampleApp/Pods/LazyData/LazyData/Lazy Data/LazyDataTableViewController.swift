//
//  LazyDataTableViewController.swift
//  Lazy Data
//
//  Created by Marcos Rodriguez on 3/26/16.
//  Copyright © 2016 Marcos Rodriguez Vélez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc public protocol LazyDataTableViewDataSource: class {
    
    func lazyDataCellForRowAtIndexPath(cell: UITableViewCell, managedObject: NSManagedObject?, indexPath: NSIndexPath)
    
    func lazyDataCellIdentifierForRowAtIndexPath(indexPath: NSIndexPath) -> String
    
    optional func lazyDataCanEditRowAtIndexPath(indexPath: NSIndexPath) -> Bool
    
    optional func lazyDataContentDidChange()
    
    optional func lazyDataDeleteObject(managedObject: NSManagedObject, forRowAtIndexPath indexPath: NSIndexPath)
    
}

@objc public class LazyDataTableViewController: NSObject, NSFetchedResultsControllerDelegate, UITableViewDataSource {
    
    public var fetchedResultsController: NSFetchedResultsController {
        didSet {
            do {
                try fetchedResultsController.performFetch()
                self.tableView.dataSource = self
                self.fetchedResultsController.delegate = self
            }
            catch {
                print("Unable to initialize. There was an error when running performFetch() on the referenced fetchedResultsController.")
            }
        }
    }
    
    private var tableView: UITableView
    
    public weak var dataSource: LazyDataTableViewDataSource? {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var useCustomEditActions: Bool = false
    
    // MARK: - Initializer
    
    public
    init?(tableView: UITableView, fetchedResultsController: NSFetchedResultsController) {
        do {
            try fetchedResultsController.performFetch()
            self.tableView = tableView
            self.fetchedResultsController = fetchedResultsController
            super.init()
            self.tableView.dataSource = self
            self.fetchedResultsController.delegate = self
        }
        catch {
            print("Unable to initialize. There was an error when running performFetch() on the referenced fetchedResultsController.")
            return nil
        }
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let managedObjectAtIndexPath = fetchedResultsController.objectAtIndexPath(indexPath) as? NSManagedObject
        
        guard let cellIdentifier = dataSource?.lazyDataCellIdentifierForRowAtIndexPath(indexPath) else {
            fatalError("LazyDataTableViewController was unable to obtain a cell identifier for:  section \(indexPath.section), row: \(indexPath.row)")
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        dataSource?.lazyDataCellForRowAtIndexPath(cell, managedObject: managedObjectAtIndexPath, indexPath: indexPath)
        return cell
    }
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        guard let lazyDataCanEditRowAtIndexPath = dataSource?.lazyDataCanEditRowAtIndexPath else {
            return false
        }
        return lazyDataCanEditRowAtIndexPath(indexPath)
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let managedObject = fetchedResultsController.objectAtIndexPath(indexPath) as? NSManagedObject else {
            return
        }
        if editingStyle == .Delete {
            if let lazyDataDeleteObject = dataSource?.lazyDataDeleteObject {
                lazyDataDeleteObject(managedObject, forRowAtIndexPath: indexPath)
            }
        }
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if fetchedResultsController.sectionIndexTitles.count >= section && fetchedResultsController.sectionIndexTitles.count != 0 {
            return fetchedResultsController.sectionIndexTitles[section]
        }
        return nil
    }
    
    public func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return fetchedResultsController.sectionIndexTitles
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if !useCustomEditActions {
            
        }
        return nil
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    public func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    public func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        }
    }
    
    public func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
        
        guard let lazyDataContentDidChange = dataSource?.lazyDataContentDidChange else {
            return
        }
        lazyDataContentDidChange()
    }
    
}