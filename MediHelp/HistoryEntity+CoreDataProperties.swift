//
//  HistoryEntity+CoreDataProperties.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 1/14/18.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//

import Foundation
import CoreData

// Defined with @objc to allow it to be used with @NSManaged.

extension HistoryEntity {
  
    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryEntity> {
        return NSFetchRequest<HistoryEntity>(entityName: "HistoryEntity")
    }

    @NSManaged public var hour: Int64
    @NSManaged public var taken: MedicationTakenState
    @NSManaged public var medication: Medication?
    @NSManaged public var historyDay: HistoryDay?

}
