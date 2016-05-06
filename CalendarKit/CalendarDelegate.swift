//
//  CalendarDelegate.swift
//  CalendarKit
//
//  Created by Steven Beyers on 6/17/15.
//  Copyright © 2015 Beyers Apps, LLC. All rights reserved.
//

import Foundation

@objc public protocol CalendarDelegate {
    
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