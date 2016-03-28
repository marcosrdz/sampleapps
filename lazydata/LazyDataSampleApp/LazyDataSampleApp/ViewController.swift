//
//  ViewController.swift
//  Test
//
//  Created by Marcos Rodriguez on 3/15/16.
//  Copyright © 2016 Marcos Rodriguez Vélez. All rights reserved.
//

import UIKit
import LazyData
import CoreData

class ViewController: UIViewController, LazyDataTableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var controller: LazyDataTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // README: - Indicate which store type you would like in your project. Persistent (SQL Lite), or Temporary (In memory)
        LazyData.configure(storeType: .Temporary)
        
        // README: - Insert a sample object into the managed object context
        LazyData.insertObject(entityName: "Person", dictionary: ["name": "Marcos"])
        
        // README: - Create a FetchedResultsController
        let fetchedResultsController = LazyData.fetchedResultsController(entityName: "Person")
    
        // README: - Let Lazy Data handle your UITableView's data source
        controller = LazyDataTableViewController(tableView: tableView, fetchedResultsController: fetchedResultsController)
        
        // README: - You are going to by LazyDataTableView's data source. This will allow you to customize your UITableViewCells
        controller?.dataSource = self
    }
    
    // MARK: - LazyDataTableViewDataSource
    
    func lazyDataCellForRowAtIndexPath(cell: UITableViewCell, managedObject: NSManagedObject?, indexPath: NSIndexPath) {
        cell.textLabel?.text = (managedObject as? Person)?.name
    }
    
    func lazyDataCellIdentifierForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        return "Cell"
    }
    
    func lazyDataCanEditRowAtIndexPath(indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func lazyDataCommitEditingStyle(editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            print("")
            LazyData.deleteObject(controller.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
        default:
            print("")
        }
    }
    
    // MARK: - Sample
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Add", message: nil, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField) in
            
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
            guard let name = alertController.textFields?.first?.text else {
                return
            }
            LazyData.insertObject(entityName: "Person", dictionary: ["name" : name])
        }))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}

