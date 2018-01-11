//
//  CoreDataManager.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 1/5/18.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    static var mainViewContext : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }()
    class public func saveMainContext() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
    init() {
    }
}
