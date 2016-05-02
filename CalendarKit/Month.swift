//
//  Month.swift
//  CalendarKit
//
//  Created by Steven Beyers on 6/7/15.
//  Copyright (c) 2015 Beyers Apps, LLC. All rights reserved.
//

import UIKit

private let monthFormatter = MonthFormatter()

internal class Month: NSObject {
    
    var date: NSDate
    
    /**
    * Creates a Month object for the date given
    *
    * @param monthDate Any date in the month that needs to be created
    **/
    required init(monthDate: NSDate) {
        date = monthDate
    }
    
    /**
    * Returns the name of the month that this object represents.
    *
    * @return The string representation of the current month
    **/
    func monthName() -> String {
        return monthFormatter.formatter.stringFromDate(date)
    }
    
    /**
    * Will determine if the current month is equal to the object specified.
    * The items will be equal if the following conditions are met:
    *   1) The object specified is a Month object
    *   2) The month of the Month object specified is the same as the current Month's month
    *   3) The year of the Month object specified is the same as the current Month's year
    *
    * @param object AnyObject that needs to be compared against the current Month
    * @return A Bool. True if the two objects are equal, otherwise false.
    **/
    override func isEqual(object: AnyObject?) -> Bool {
        if let otherMonth = object as? Month {
            let myComponents = NSCalendar.currentCalendar().components([.Month, .Year], fromDate: date)
            let otherComponents = NSCalendar.currentCalendar().components([.Month, .Year], fromDate: otherMonth.date)
            
            if (myComponents.month == otherComponents.month && myComponents.year == otherComponents.year) {
                return true
            }
        }
        
        return false
    }
   
}

/**
* This extension will give us class methods to create a month based off of a previous month
**/
extension Month {
    
    /**
    * Convenience initializer so that a month can be created based
    * on another month.
    *
    * @param otherMonth The base month used as a reference to create a new Month
    * @param offset The number of months between the otherMonth and the desired month
    **/
    convenience init(otherMonth: Month, offsetMonths offset: Int) {
        let date = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: offset, toDate: otherMonth.date, options: [])!
        self.init(monthDate: date)
    }
    
}

/**
* This extension will provide helpers for determining the correct date
**/
extension Month {
    
    /**
    * This returns the days in the current month
    **/
    func numberOfDaysInMonth() -> Int {
        let calendar = NSCalendar.currentCalendar()
        var components = calendar.components([.Day, .Month, .Year], fromDate: date)
        components.day = 1
        let firstDayDate = calendar.dateFromComponents(components)
        
        let delta : NSDateComponents = NSDateComponents()
        delta.month = 1
        delta.day = -1
        
        let newDate = calendar.dateByAddingComponents(delta, toDate: firstDayDate!, options: [])
        if let lastDayDate = newDate {
            components = calendar.components(.Day, fromDate: lastDayDate)
            return components.day
        }
        
        return -1
    }
    
    /**
    * This returns the first day of the week as an integer value from 0-6 (Sunday - Saturday)
    **/
    func firstDayOfWeek() -> Int {
        let calendar = NSCalendar.currentCalendar()
        var components = calendar.components([.Day, .Month, .Year, .Weekday], fromDate: date)
        components.day = 1
        components = calendar.components([.Day, .Month, .Year, .Weekday], fromDate: calendar.dateFromComponents(components)!)
        var day = components.weekday
        day -= 1
        
        return day
    }
    
    /**
    * This returns the number of weeks for this month
    **/
    func weeksInMonth() -> Int {
        let numberOfDays = numberOfDaysInMonth()
        let firstDay = firstDayOfWeek()
        let totalDaysNeeded = numberOfDays + firstDay
        
        var numberOfWeeks = totalDaysNeeded / 7
        let remainder = totalDaysNeeded % 7
        
        if (remainder > 0) {
            numberOfWeeks += 1
        }
        
        return numberOfWeeks
    }
    
    func getDateForCell(indexPath path: NSIndexPath) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year, .Weekday], fromDate: date)
        var dayOfMonth = path.row
        let firstDay = firstDayOfWeek()
        // subtract the offset to account for the first day of the week
        dayOfMonth -= (firstDay - 1)
        
        var dateToReturn: NSDate?
        components.day = dayOfMonth

        // The date is in the current month
        let newDate = calendar.dateFromComponents(components)

        dateToReturn = newDate

        if let returnDate = dateToReturn {
            return returnDate
        } else {
            // If I was not able to determine the date I'm just going to return toay's date
            return date
        }
    }
    
    func isDateInMonth(testDate: NSDate) -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month], fromDate: testDate)
        let currentComponents = calendar.components([.Month], fromDate: date)
        
        if (components.month == currentComponents.month) {
            return false
        }
        
        return true
    }
    
}

/**
 This is a singleton so that we only ever have to create one month formatter
 */
private class MonthFormatter {
    
    lazy var formatter: NSDateFormatter = {
       let newFormatter = NSDateFormatter()
        newFormatter.dateFormat = "MMMM"
        
        return newFormatter
    }()
    
}
