//
//  ViewController.swift
//  LazyDataSampleApp
//
//  Created by Marcos Rodriguez on 3/14/16.
//  Copyright © 2016 Marcos Rodriguez Vélez. All rights reserved.
//

import UIKit
import LazyData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        LazyData.dataModel(name: "LazyDataSampleApp")
        LazyData.sharedInstance.insertObject(entityName: "Dog", dictionary: ["name": "Hot Dog", "breed": "Corgi"])
        let objectsInContext = LazyData.fetchObjects(entityName: "Dog")
        
        print("Objects in Lazy Data: \(objectsInContext)")
    }

}

