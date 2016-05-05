//
//  CalendarConfiguration.swift
//  CalendarKit
//
//  Created by Steven Beyers on 4/30/16.
//  Copyright © 2016 Beyers Apps, LLC. All rights reserved.
//

import Foundation

/**
 The list of possible styles for the calendar.
 */
public enum DisplayStyle {
    /// The default display style set up for full screen calendars.
    case FullScreen
    /// The default display style set up for using the calendar as a UITextField's input view.
    case InputView
    /// Fully custom display. Any values that are not specified will revert to the default values of the <code>FullScreen</code> display.
    case Custom
}

/**
 The styles available for the date cells. These options are the styles available for placement of the date text in a cell
 */
public enum DateCellStyle {
    // Puts the date text near the top of the cell at a constant distance from the top and centered horizontally.
    case TopCenter(verticalOffset: CGFloat)
    // Puts the date text near the top-left of the cell at a constant distance from the top and a constant distance from the left.
    case TopLeft(verticalOffset: CGFloat, horizontalOffset: CGFloat)
    // Puts the date text near the top-right of the cell at a constant distance from the top and a constant distance from the right.
    case TopRight(verticalOffset: CGFloat, horizontalOffset: CGFloat)
    // Puts the date text centered vertically and horizontally in the date cell.
    case CenterCenter
    // Puts the date text near the left of the cell centered vertically and a constant distance from the left.
    case CenterLeft(horizontalOffset: CGFloat)
    // Puts the date text near the right of the cell centered vertically and a constant distance from the right.
    case CenterRight(horizontalOffset: CGFloat)
    // Puts the date text near the bottom of the cell at a constant distance from the bottom and centered horizontally.
    case BottomCenter(verticalOffset: CGFloat)
    // Puts the date text near the bottom-left of the cell at a constant distance from the bottom and a constant distance from the left.
    case BottomLeft(verticalOffset: CGFloat, horizontalOffset: CGFloat)
    // Puts the date text near the bottom-right of the cell at a constant distance from the bottom and a constant distance from the right.
    case BottomRight(verticalOffset: CGFloat, horizontalOffset: CGFloat)
}

public struct CalendarConfiguration {

    var displayStyle: DisplayStyle
    var dateTextStyle: DateCellStyle
    var dateCircleSizeOffset: CGFloat?
    var monthHeaderFont: UIFont
    var dayHeaderFont: UIFont
    var dateLabelFont: UIFont
    var headerBackgroundColor: UIColor
    var weekdayHeaderBackgroundColor: UIColor
    var dateHighlightColor: UIColor
    var dateBackgroundColor: UIColor
    var dateDisabledBackgroundColor: UIColor
    var calendarBackgroundColor: UIColor
    var dateTextEnabledColor: UIColor
    var dateTextDisabledColor: UIColor
    var dateTextSelectedColor: UIColor
    var dateTextHighlightedColor: UIColor
    
    public static func FullScreenConfiguration() -> CalendarConfiguration {
        return CalendarConfiguration(displayStyle: .FullScreen, dateTextStyle: .TopCenter(verticalOffset: 17), monthHeaderFont: UIFont.preferredMonthHeaderFont(), dayHeaderFont: UIFont.preferredWeekdayHeaderFont(), dateLabelFont: UIFont.preferredDateFont(), headerBackgroundColor: CalendarDesignKit.calendarDateColor, weekdayHeaderBackgroundColor: UIColor.lightGrayColor(), dateHighlightColor: CalendarDesignKit.calendarDateColor, dateBackgroundColor: CalendarDesignKit.dateBackgroundColor, dateDisabledBackgroundColor: CalendarDesignKit.calendarDisabledDateColor, calendarBackgroundColor: CalendarDesignKit.calendarBackgroundColor, dateTextEnabledColor: UIColor.blackColor(), dateTextDisabledColor: UIColor.whiteColor().colorWithAlphaComponent(0.6), dateTextSelectedColor: UIColor.whiteColor(), dateTextHighlightedColor: UIColor.blackColor().colorWithAlphaComponent(0.3))
    }
    
    public static func InputViewConfiguration() -> CalendarConfiguration {
        return CalendarConfiguration(displayStyle: .InputView, dateTextStyle: .CenterCenter, dateCircleSizeOffset: 8, monthHeaderFont: UIFont.preferredInputViewMonthHeaderFont(), dayHeaderFont: UIFont.preferredInputViewWeekdayHeaderFont(), dateLabelFont: UIFont.preferredInputViewDateFont(), headerBackgroundColor: CalendarDesignKit.calendarDateColor, weekdayHeaderBackgroundColor: UIColor.lightGrayColor(), dateHighlightColor: CalendarDesignKit.calendarDateColor, dateBackgroundColor: CalendarDesignKit.dateBackgroundColor, dateDisabledBackgroundColor: CalendarDesignKit.calendarDisabledDateColor, calendarBackgroundColor: CalendarDesignKit.calendarBackgroundColor, dateTextEnabledColor: UIColor.blackColor(), dateTextDisabledColor: UIColor.whiteColor().colorWithAlphaComponent(0.6), dateTextSelectedColor: UIColor.whiteColor(), dateTextHighlightedColor: UIColor.blackColor().colorWithAlphaComponent(0.3))
    }
    
    /**
     Initializer to setup the configuration.
    */
    public init(displayStyle: DisplayStyle, dateTextStyle: DateCellStyle, dateCircleSizeOffset: CGFloat? = nil, monthHeaderFont: UIFont, dayHeaderFont: UIFont, dateLabelFont: UIFont, headerBackgroundColor: UIColor, weekdayHeaderBackgroundColor: UIColor, dateHighlightColor: UIColor, dateBackgroundColor: UIColor, dateDisabledBackgroundColor: UIColor, calendarBackgroundColor: UIColor, dateTextEnabledColor: UIColor, dateTextDisabledColor: UIColor, dateTextSelectedColor: UIColor, dateTextHighlightedColor: UIColor) {
        self.displayStyle = displayStyle
        self.dateTextStyle = dateTextStyle
        self.dateCircleSizeOffset = dateCircleSizeOffset
        self.monthHeaderFont = monthHeaderFont
        self.dayHeaderFont = dayHeaderFont
        self.dateLabelFont = dateLabelFont
        self.headerBackgroundColor = headerBackgroundColor
        self.weekdayHeaderBackgroundColor = weekdayHeaderBackgroundColor
        self.dateHighlightColor = dateHighlightColor
        self.dateBackgroundColor = dateBackgroundColor
        self.dateDisabledBackgroundColor = dateDisabledBackgroundColor
        self.calendarBackgroundColor = calendarBackgroundColor
        self.dateTextEnabledColor = dateTextEnabledColor
        self.dateTextDisabledColor = dateTextDisabledColor
        self.dateTextSelectedColor = dateTextSelectedColor
        self.dateTextHighlightedColor = dateTextHighlightedColor
    }
    
}
