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
    
    func lazyDataCellForRowAtIndexPath(cell cell: UITableViewCell, managedObject: NSManagedObject?, indexPath: NSIndexPath) {
        cell.textLabel?.text = (managedObject as? Person)?.name
    }
    
    func lazyDataCellIdentifierForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        return "Cell"
    }
    
}

