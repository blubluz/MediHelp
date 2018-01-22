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
import SwiftyJSON
extension Medication {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medication> {
        return NSFetchRequest<Medication>(entityName: "Medication")
    }
    @nonobjc public func configureWithJson(json: JSON){
        self.name = json["name"].string
        self.tagColor = UIColor.color(withHex: json["tag_color"].string)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        startDate = dateFormatter.date(from: json["start_date"].string!)! as NSDate
        endDate = dateFormatter.date(from: json["end_date"].string!)! as NSDate
        dosage?.amount = json["dosage"]["amount"].float!
        dosage?.units = json["dosage"]["units"].string
        frequency?.days = json["frequency"]["days"].arrayObject as? [Int]
        frequency?.intervalAmount = json["frequency"]["interval_amount"].int16!
        frequency?.timesPerDay = json["frequency"]["times_per_day"].int64!
        frequency?.times = json["frequency"]["times"].arrayObject as? [Int]
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
