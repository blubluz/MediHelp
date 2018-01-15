//
//  Medication+CoreDataProperties.swift
//  MediHelp
//
//  Created by Mihai Honceriu on 15/01/2018.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

extension Medication {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medication> {
        return NSFetchRequest<Medication>(entityName: "Medication")
    }

    @NSManaged public var endDate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var tagColor: UIColor?
    @NSManaged public var dosage: Dosage?
    @NSManaged public var frequency: Frequency?
    @NSManaged public var historyEntities: NSSet?

}

// MARK: Generated accessors for historyEntities
extension Medication {

    @objc(addHistoryEntitiesObject:)
    @NSManaged public func addToHistoryEntities(_ value: HistoryEntity)

    @objc(removeHistoryEntitiesObject:)
    @NSManaged public func removeFromHistoryEntities(_ value: HistoryEntity)

    @objc(addHistoryEntities:)
    @NSManaged public func addToHistoryEntities(_ values: NSSet)

    @objc(removeHistoryEntities:)
    @NSManaged public func removeFromHistoryEntities(_ values: NSSet)

}
