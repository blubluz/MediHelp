//
//  Frequency+CoreDataProperties.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 1/14/18.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//

import Foundation
import CoreData


extension Frequency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Frequency> {
        return NSFetchRequest<Frequency>(entityName: "Frequency")
    }

    @NSManaged public var intervalAmount: Int16
    @NSManaged public var timesPerDay: Int64
    @NSManaged public var days: [Int]?
    @NSManaged public var medication: Medication?
    @NSManaged public var times: NSSet?

}

// MARK: Generated accessors for times
extension Frequency {

    @objc(addTimesObject:)
    @NSManaged public func addToTimes(_ value: Time)

    @objc(removeTimesObject:)
    @NSManaged public func removeFromTimes(_ value: Time)

    @objc(addTimes:)
    @NSManaged public func addToTimes(_ values: NSSet)

    @objc(removeTimes:)
    @NSManaged public func removeFromTimes(_ values: NSSet)

}
