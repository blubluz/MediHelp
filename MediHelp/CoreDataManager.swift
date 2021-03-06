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
	class public func getMeds() -> [Medication]? {
		let medsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Medication")
		do{
			let fetchedMeds = try CoreDataManager.mainViewContext.fetch(medsFetch) as! [Medication]
			if fetchedMeds.count > 0 {
				return fetchedMeds
			}else{
				return nil
			}
		}catch {
			fatalError("Failed to fetch HistoryDays: \(error)")
			return nil
		}
	}
	class public func getHistoryDays() -> [HistoryDay]? {
		let historyDaysFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryDay")
		let sortDescriptor = NSSortDescriptor(key: "day", ascending: true)
		historyDaysFetch.sortDescriptors = [sortDescriptor]
		do{
			let fetchedHistoryDays = try CoreDataManager.mainViewContext.fetch(historyDaysFetch) as! [HistoryDay]
			if fetchedHistoryDays.count > 0 {
				return fetchedHistoryDays
			}else{
				return nil
			}
		}catch {
			fatalError("Failed to fetch HistoryDays: \(error)")
			return nil
		}
	}
	class public func resyncHistoryEntities() {
		let historyDaysFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryDay")
		historyDaysFetch.predicate = NSPredicate(format: "day <= %@", Date() as NSDate)
		let sortDescriptor = NSSortDescriptor(key: "day", ascending: true)
		historyDaysFetch.sortDescriptors = [sortDescriptor]
		do{
            let calendar = Calendar.current

			let fetchedHistoryDays = try CoreDataManager.mainViewContext.fetch(historyDaysFetch) as! [HistoryDay]
			if fetchedHistoryDays.count > 0 {
				for historyDay in fetchedHistoryDays {
					for historyEntity in (historyDay.historyEntities?.sortedArray(using: [NSSortDescriptor(key: "hour", ascending: true)]))! {
						if let historyEntity = historyEntity as? HistoryEntity {
                            let timeInterval = Date().timeIntervalSince1970 - calendar.startOfDay(for: Date()).timeIntervalSince1970
							if(historyEntity.taken == .unknown){
                                if(historyDay.day! == calendar.startOfDay(for: Date()) as NSDate){
                                    if(Double(historyEntity.hour) <= timeInterval){
                                        historyEntity.taken = .notTaken
                                    }
                                }else{
                                    historyEntity.taken = .notTaken
                                }
							}
						}
					}
				}
				saveMainContext()
			}
		}catch {
			fatalError("Failed to fetch HistoryDays: \(error)")
		}
	}
    class public func generateNewHistoryFor(medication : Medication) {
        var numberOfDays = 30
        let calendar = Calendar.current
        // Replace the hour (time) of both dates with 00:00
        let startDate = calendar.startOfDay(for: medication.startDate! as Date)
		
		if let medEndDate = medication.endDate as Date? {
			let endDate = calendar.startOfDay(for: medEndDate)
			let components = calendar.dateComponents([.day], from: startDate, to: endDate)
			
			if let days = components.day{
				numberOfDays = days  // This will return the number of day(s) between dates
			}
		}
		let endDate = startDate.addingTimeInterval(TimeInterval(numberOfDays*60*60*24))
        let historyDaysFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryDay")
        historyDaysFetch.predicate = NSPredicate(format: "day >= %@ && day <= %@", startDate as NSDate, endDate as NSDate)
        let sortDescriptor = NSSortDescriptor(key: "day", ascending: true)
        historyDaysFetch.sortDescriptors = [sortDescriptor]
        
        do{
            let fetchedHistoryDays = try CoreDataManager.mainViewContext.fetch(historyDaysFetch) as! [HistoryDay]
            var intervalAmount = 1
            if let interval = medication.frequency?.intervalAmount {
				if(interval > 0 ){
                	intervalAmount = Int(interval)
				}
            }
            for index in stride(from: 0, to: numberOfDays, by:intervalAmount) {
                let newDate = Date(timeInterval: TimeInterval(24*60*60*index), since: startDate)
                if medication.frequency?.days?.contains(newDate.dayNumber()) == false {
                    continue
                }
                let historyDay = getHistoryDayFrom(historyDays: fetchedHistoryDays, withDate: newDate)
                if let sortedTimesArray = medication.frequency?.times?.sorted() {
                    for time in sortedTimesArray {
                        let historyEntity = HistoryEntity(entity: NSEntityDescription.entity(forEntityName: "HistoryEntity", in: mainViewContext)!, insertInto: mainViewContext)
                        historyEntity.hour = Int64(time)
                        historyEntity.medication = medication
                        let timeInterval = Date().timeIntervalSince1970 - calendar.startOfDay(for: Date()).timeIntervalSince1970
                        
                        if(newDate <= calendar.startOfDay(for: Date()) && Double(time) <= timeInterval){
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
