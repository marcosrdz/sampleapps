//
//  Device+CoreDataProperties.swift
//  Test
//
//  Created by Marcos Rodriguez on 3/27/16.
//  Copyright © 2016 Marcos Rodriguez Vélez. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Device {

    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var owner: Person?

}
