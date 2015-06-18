//
//  CalendarDelegate.swift
//  CalendarKit
//
//  Created by Steven Beyers on 6/17/15.
//  Copyright © 2015 Beyers Apps, LLC. All rights reserved.
//

import Foundation

@objc protocol CalendarDelegate {
    
    //MARK: These methods ask the user for more information
    
    /**
    * Asks the delegate if the calendar height is dynamic. If it is dynamic then 
    * the height of the rows in the calendar will remain static. This means that
    * the calendar will need less vertical space for 4 week months and more
    * vertical space for 6 week months. If the calendar height is not dynamic
    * then the calendar will adjust the row heights to fill the calendar
    *
    * @return Bool value to indicate if the calendar has a dynamic height
    **/
    optional func isCalendarHeightDynamic() -> Bool
    
    /**
    * Asks the delegate what the standard height for each row should be. The delegate 
    * should keep in mind that there will always be 2px padding between each row and
    * the month and day headers will never shrink.
    *
    * @return CGFloat The static height of each row
    **/
    optional func rowHeightForDynamicCalendar() -> CGFloat
    
    //MARK: These methods let the user know whats happening
    
    /**
    * Notifies the delegate that a new date was selected.
    *
    * @parameter calendar The calendar that selected the new date
    * @parameter date The new date that was selected
    **/
    optional func calendar(calendar: Calendar, didSelectDate date: NSDate)
    
    /**
    * Notifies the delegate that the calendar scrolled to a new month. This
    * should be used when the delgate responds <true> to isCalendarHeightDynamic().
    * Using this method the delgate will have an oportunity to adjust any constraints
    * it has imposed upon the calendar to account for a new height
    *
    * @parameter calendar The calendar that scrolled to a new date
    * @parameter date A random day in the month that was selected
    * @parameter weeks The number of weeks in the new month
    **/
    optional func calendar(calendar: Calendar, didScrollToDate date: NSDate, withNumberOfWeeks weeks: Int)
    
}