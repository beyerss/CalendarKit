//
//  MonthTests.swift
//  CalendarKit
//
//  Created by Steven Beyers on 6/17/16.
//  Copyright © 2016 Beyers Apps, LLC. All rights reserved.
//

import XCTest
@testable import CalendarKit

class MonthTests: XCTestCase {
    
    let initialDate = NSDate()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func createMonth() -> Month {
        return Month(monthDate: initialDate)
    }
    
    func testCreateMonth() {
        XCTAssertTrue(initialDate == createMonth().date, "Date not set properly")
    }
    
    func testMonthName() {
        let month = createMonth()
        let dateFormat = "MMM"
        month.useMonthFormat(dateFormat)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        let name = dateFormatter.stringFromDate(month.date)
        
        XCTAssertTrue(name == month.monthName(), "The month name should be \(name)")
    }
    
    func testIsEqualTrue() {
        let firstMonth = createMonth()
        let secondMonth = createMonth()
        
        XCTAssertTrue(firstMonth.isEqual(firstMonth), "A Month should be equal to itself")
        XCTAssertTrue(firstMonth.isEqual(secondMonth), "A month should be equal to another month in the same month and year")
        XCTAssertTrue(secondMonth.isEqual(firstMonth), "Reversing the months should produce the same result")
    }
    
    func testIsEqualForNonMonth() {
        let firstMonth = createMonth()
        let secondObject = NSObject()
        
        XCTAssertFalse(firstMonth.isEqual(secondObject), "A month is not equal to a non-Month object")
    }
    
    func testIsEqualForOutsideOfMonth() {
        let firstMonth = createMonth()
        let secondMonth = Month(monthDate: NSDate(timeIntervalSinceNow: 60*60*24*32))
        
        XCTAssertFalse(firstMonth.isEqual(secondMonth), "A month is not equal to a Month object in another month")
    }
    
    func testIsEqualForOutsideOfYear() {
        let firstMonth = createMonth()
        let secondMonth = Month(monthDate: NSDate(timeIntervalSinceNow: 60*60*24*365))
        
        XCTAssertFalse(firstMonth.isEqual(secondMonth), "A month is not equal to a month object of the same month but a different year")
    }
    
    func testCreateMonthWithOffset() {
        let firstMonth = createMonth()
        
        for i in 0...10 {
            let nextMonthDate = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: i, toDate: initialDate, options: [])!
            let secondMonth = Month(otherMonth: firstMonth, offsetMonths: i)
            
            XCTAssertTrue(nextMonthDate == secondMonth.date, "Date of second month should be the same as the next month date")
        }
    }
    
    func testNumberOfDaysInMonth() {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
        components.year = 2016
        components.day = 1
        
        for i in 1...12 {
            let correctNumberOfDats: Int
            switch i {
            case 1:
                correctNumberOfDats = 31
            case 2:
                correctNumberOfDats = 29 // 2016 is a leap year
            case 3:
                correctNumberOfDats = 31
            case 4:
                correctNumberOfDats = 30
            case 5:
                correctNumberOfDats = 31
            case 6:
                correctNumberOfDats = 30
            case 7:
                correctNumberOfDats = 31
            case 8:
                correctNumberOfDats = 31
            case 9:
                correctNumberOfDats = 30
            case 10:
                correctNumberOfDats = 31
            case 11:
                correctNumberOfDats = 30
            default:
                correctNumberOfDats = 31
            }
            
            components.month = i
            if let dateFromComponents = calendar.dateFromComponents(components) {
                let month = Month(monthDate: dateFromComponents)
                XCTAssertTrue(correctNumberOfDats == month.numberOfDaysInMonth(), "Incorrect number of days in month returned.")
            } else {
                XCTFail("The month date was not created")
            }
        }
    }
    
    func testFirstDayOfWeek() {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
        components.year = 2016
        components.day = 1
        
        for i in 1...12 {
            let firstDay: Int
            switch i {
            case 1:
                firstDay = 5
            case 2:
                firstDay = 1
            case 3:
                firstDay = 2
            case 4:
                firstDay = 5
            case 5:
                firstDay = 0
            case 6:
                firstDay = 3
            case 7:
                firstDay = 5
            case 8:
                firstDay = 1
            case 9:
                firstDay = 4
            case 10:
                firstDay = 6
            case 11:
                firstDay = 2
            default:
                firstDay = 4
            }
            
            components.month = i
            if let dateFromComponents = calendar.dateFromComponents(components) {
                let month = Month(monthDate: dateFromComponents)
                XCTAssertTrue(firstDay == month.firstDayOfWeek(), "Incorrect first day returned.")
            } else {
                XCTFail("The month date was not created")
            }
        }
    }
    
    func testWeeksInMonth() {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
        components.day = 1
        
        for i in 1...12 {
            components.year = 2016
            
            let numberOfWeeks: Int
            switch i {
            case 1:
                numberOfWeeks = 6
            case 2:
                // set the year to 2015 since it is exactly 4 weeks
                components.year = 2015
                numberOfWeeks = 4
            case 3:
                numberOfWeeks = 5
            case 4:
                numberOfWeeks = 5
            case 5:
                numberOfWeeks = 5
            case 6:
                numberOfWeeks = 5
            case 7:
                numberOfWeeks = 6
            case 8:
                numberOfWeeks = 5
            case 9:
                numberOfWeeks = 5
            case 10:
                numberOfWeeks = 6
            case 11:
                numberOfWeeks = 5
            default:
                numberOfWeeks = 5
            }
            
            components.month = i
            if let dateFromComponents = calendar.dateFromComponents(components) {
                let month = Month(monthDate: dateFromComponents)
                XCTAssertTrue(numberOfWeeks == month.weeksInMonth(), "Incorrect weeks in month returned.")
            } else {
                XCTFail("The month date was not created")
            }
        }
    }
    
    func testGetDateForCell() {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
        components.day = 1
        components.month = 6
        components.year = 2016
        
        let month: Month
        
        guard let dateFromComponents = calendar.dateFromComponents(components) else {
            XCTFail("Could not create first date from components")
            return
        }
        month = Month(monthDate: dateFromComponents)
        
        for i in 3...30 {
            let retDate = month.getDateForCell(indexPath: NSIndexPath(forRow: i, inSection: 0))
            let retComponents = calendar.components([.Day, .Month, .Year], fromDate: retDate)
            
            XCTAssertTrue(retComponents.day == components.day, "The returned day is not correct")
            XCTAssertTrue(retComponents.month == components.month, "The returned month is not correct")
            XCTAssertTrue(retComponents.year == components.year, "The returned year is not correct")
            
            components.day = components.day + 1
        }
    }
    
    func testIsDateOutOfMonthFalse() {
        XCTAssertFalse(createMonth().isDateOutOfMonth(initialDate), "The initial date should never be outside of the month")
    }
    
    func testIsDateOutOfMonthTrue() {
        XCTAssertTrue(createMonth().isDateOutOfMonth(NSDate(timeIntervalSinceNow: 60*60*24*40)), "The date should always be outside of the month")
    }
    
}
