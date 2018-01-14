//
//  DateExtension.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 1/14/18.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//

import Foundation
public extension Date {
    /**
     Returns day of the week as an integer. 
     
     Can return values from 0 to 6.
     
     0 = Saturday
     
     1 = Sunday
     
     2 = Monday
     
       ...
     
     6 = Friday
     
     */
    public func dayNumber() -> Int {
        let myCalendar = Calendar.current
        return (myCalendar.component(.weekday, from: self)%7)
    }
}
