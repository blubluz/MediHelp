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
    class public func generateNewHistoryFor(medication : Medication) {
        var numberOfDays = 30
        let calendar = Calendar.current
        // Replace the hour (time) of both dates with 00:00
        let startDate = calendar.startOfDay(for: medication.startDate! as Date)
        let endDate = calendar.startOfDay(for: medication.endDate! as Date)
        
        if(medication.endDate != nil){
            let components = calendar.dateComponents([.day], from: startDate, to: endDate)

            if let days = components.day{
                numberOfDays = days  // This will return the number of day(s) between dates
            }
        }
        let historyDaysFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryDay")
        historyDaysFetch.predicate = NSPredicate(format: "day >= %@ && day <= %@", startDate as NSDate, endDate as NSDate)
        let sortDescriptor = NSSortDescriptor(key: "day", ascending: true)
        historyDaysFetch.sortDescriptors = [sortDescriptor]
        
        do{
            let fetchedHistoryDays = try CoreDataManager.mainViewContext.fetch(historyDaysFetch) as! [HistoryDay]
            var intervalAmount = 1
            if let interval = medication.frequency?.intervalAmount {
                intervalAmount = Int(interval)
            }
            for index in stride(from: 0, to: numberOfDays, by:intervalAmount) {
                let newDate = Date(timeInterval: TimeInterval(24*60*60*index), since: startDate)
                if medication.frequency?.days?.contains(newDate.dayNumber()) == false {
                    continue
                }
                let historyDay = getHistoryDayFrom(historyDays: fetchedHistoryDays, withDate: newDate)
                if let sortedTimesArray = medication.frequency?.times?.sortedArray(using: [NSSortDescriptor(key: "time", ascending: true)]) as? [Int64]  {
                    for time in sortedTimesArray {
                        let historyEntity = HistoryEntity(entity: NSEntityDescription.entity(forEntityName: "HistoryEntity", in: mainViewContext)!, insertInto: mainViewContext)
                        historyEntity.hour = time
                        historyEntity.medication = medication
                        if(startDate < Date()){
                            historyEntity.taken = .notTaken
                        }else{
                            historyEntity.taken = .unknown
                        }
                        historyDay.addToHistoryEntities(historyEntity)
                    }
                }
            }
            saveMainContext()
        } catch{
            fatalError("Failed to fetch HistoryDays: \(error)")
        }
    }
    class func getHistoryDayFrom(historyDays : [HistoryDay], withDate : Date) -> HistoryDay{
        for historyDay in historyDays {
            //sometimes i hate swift
            if let date = historyDay.day{
                let swiftDate = date as Date
                if swiftDate == withDate {
                    return historyDay
                }
            }
        }
        let historyDay = HistoryDay(entity: NSEntityDescription.entity(forEntityName: "HistoryDay", in: mainViewContext)!, insertInto: mainViewContext)
        historyDay.day = withDate as NSDate
        return historyDay
    }
    init() {
    }
}
