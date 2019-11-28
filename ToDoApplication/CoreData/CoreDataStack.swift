//
//  CoreDataStack.swift
//  ToDoApplication
//
//  Created by Dheeraj Arora on 08/11/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataStack {
    var container: NSPersistentContainer {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores{ description, error in
            guard  error == nil else{
                print("Error:\(String(describing: error))")
                return

            }

        }
    return container
    }

    var manageContext: NSManagedObjectContext{
        return container.viewContext
    }
   
}
