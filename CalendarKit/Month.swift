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
    
    var date: Date
    
    /**
    * Creates a Month object for the date given
    *
    * @param monthDate Any date in the month that needs to be created
    **/
    required init(monthDate: Date) {
        date = monthDate
    }
    
    /**
    * Returns the name of the month that this object represents.
    *
    * @return The string representation of the current month
    **/
    func monthName() -> String {
        return monthFormatter.formatter.string(from: date)
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
    override func isEqual(_ object: AnyObject?) -> Bool {
        if let otherMonth = object as? Month {
            let myComponents = Foundation.Calendar.current().components([.month, .year], from: date)
            let otherComponents = Foundation.Calendar.current().components([.month, .year], from: otherMonth.date)
            
            if (myComponents.month == otherComponents.month && myComponents.year == otherComponents.year) {
                return true
            }
        }
        
        return false
    }
    
    /**
     Sets the format used when getting the month name.
    */
    func useMonthFormat(_ format: String) {
        monthFormatter.formatter.dateFormat = format
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
        let date = Foundation.Calendar.current().date(byAdding: .month, value: offset, to: otherMonth.date, options: [])!
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
        let calendar = Foundation.Calendar.current()
        var components = calendar.components([.day, .month, .year], from: date)
        components.day = 1
        let firstDayDate = calendar.date(from: components)
        
        var delta : DateComponents = DateComponents()
        delta.month = 1
        delta.day = -1
        
        let newDate = calendar.date(byAdding: delta, to: firstDayDate!, options: [])
        if let lastDayDate = newDate {
            components = calendar.components(.day, from: lastDayDate)
            return components.day!
        }
        
        return -1
    }
    
    /**
    * This returns the first day of the week as an integer value from 0-6 (Sunday - Saturday)
    **/
    func firstDayOfWeek() -> Int {
        let calendar = Foundation.Calendar.current()
        var components = calendar.components([.day, .month, .year, .weekday], from: date)
        components.day = 1
        components = calendar.components([.day, .month, .year, .weekday], from: calendar.date(from: components)!)
        if let day = components.weekday {
            return day-1
        }
        
        return -1
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
    
    func getDateForCell(indexPath path: IndexPath) -> Date {
        let calendar = Foundation.Calendar.current()
        var components = calendar.components([.day, .month, .year, .weekday], from: date)
        var dayOfMonth = (path as NSIndexPath).row
        let firstDay = firstDayOfWeek()
        // subtract the offset to account for the first day of the week
        dayOfMonth -= (firstDay - 1)
        
        var dateToReturn: Date?
        components.day = dayOfMonth

        // The date is in the current month
        let newDate = calendar.date(from: components)

        dateToReturn = newDate

        if let returnDate = dateToReturn {
            return returnDate
        } else {
            // If I was not able to determine the date I'm just going to return toay's date
            return date
        }
    }
    
    func isDateOutOfMonth(_ testDate: Date) -> Bool {
        let calendar = Foundation.Calendar.current()
        let components = calendar.components([.month], from: testDate)
        let currentComponents = calendar.components([.month], from: date)
        
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
    
    lazy var formatter: DateFormatter = {
       let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMMM"
        
        return newFormatter
    }()
    
}
