//
//  Month.swift
//  CalendarKit
//
//  Created by Steven Beyers on 6/7/15.
//  Copyright (c) 2015 Beyers Apps, LLC. All rights reserved.
//

import UIKit

internal class Month: NSObject {
    
    var date: NSDate
    
    required init(monthDate: NSDate) {
        date = monthDate
    }
    
    func monthName(formatter: NSDateFormatter) -> String {
        return formatter.stringFromDate(date)
    }
    
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
        if (day == 7) {
            day = 0
        } else {
            day--
        }
        
        return day
    }
    
    /*
    * This returns the number of weeks for this month
    **/
    func weeksInMonth() -> Int {
        let numberOfDays = numberOfDaysInMonth()
        let firstDay = firstDayOfWeek()
        let totalDaysNeeded = numberOfDays + firstDay
        
        var numberOfWeeks = totalDaysNeeded / 7
        let remainder = totalDaysNeeded % 7
        
        if (remainder > 0) {
            numberOfWeeks++
        }
        
        return numberOfWeeks
    }
    
    func columnAtIndex(index: NSIndexPath) -> Int {
        return index.row / weeksInMonth()
    }
    
    func getDateForCell(indexPath path: NSIndexPath) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year, .Weekday], fromDate: date)
        var dayOfMonth = path.row
        let firstDay = firstDayOfWeek()
        // subtract the offset to account for the first day of the week
        dayOfMonth -= firstDay
        
        var dateToReturn: NSDate?
        let column = columnAtIndex(path)
        let row = path.row % weeksInMonth()
        
        let day = column - firstDay + 1 + (row * 7)
        components.day = day
        
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
    
}
