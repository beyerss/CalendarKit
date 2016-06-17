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
    case fullScreen
    /// The default display style set up for using the calendar as a UITextField's input view.
    case inputView
    /// Fully custom display. Any values that are not specified will revert to the default values of the <code>FullScreen</code> display.
    case custom
}

/**
 The styles available for the date cells. These options are the styles available for placement of the date text in a cell
 */
public enum ViewPlacement {
    /// Puts the date text near the top of the cell at a constant distance from the top and centered horizontally.
    case topCenter(verticalOffset: CGFloat)
    /// Puts the date text near the top-left of the cell at a constant distance from the top and a constant distance from the left.
    case topLeft(verticalOffset: CGFloat, horizontalOffset: CGFloat)
    /// Puts the date text near the top-right of the cell at a constant distance from the top and a constant distance from the right.
    case topRight(verticalOffset: CGFloat, horizontalOffset: CGFloat)
    /// Puts the date text centered vertically and horizontally in the date cell.
    case centerCenter
    /// Puts the date text near the left of the cell centered vertically and a constant distance from the left.
    case centerLeft(horizontalOffset: CGFloat)
    /// Puts the date text near the right of the cell centered vertically and a constant distance from the right.
    case centerRight(horizontalOffset: CGFloat)
    /// Puts the date text near the bottom of the cell at a constant distance from the bottom and centered horizontally.
    case bottomCenter(verticalOffset: CGFloat)
    /// Puts the date text near the bottom-left of the cell at a constant distance from the bottom and a constant distance from the left.
    case bottomLeft(verticalOffset: CGFloat, horizontalOffset: CGFloat)
    /// Puts the date text near the bottom-right of the cell at a constant distance from the bottom and a constant distance from the right.
    case bottomRight(verticalOffset: CGFloat, horizontalOffset: CGFloat)
}

/**
 The configuration for a date cell
 */
public struct DateCellConfiguration {
    
    /// The text style that determines the placement of the cell text.
    private(set) public var textStyle: ViewPlacement
    /// The offset of the circle size. Default circle size will be half of the the smaller of the two dimensions (height and width).
    private(set) public var circleSizeOffset: CGFloat?
    /// The font for the text.
    private(set) public var font: UIFont
    /// The background color of the cell.
    private(set) public var backgroundColor: UIColor
    /// The background color of the cell if the date is disabled.
    private(set) public var disabledBackgroundColor: UIColor
    /// The highlight color of the cell
    private(set) public var highlightColor: UIColor
    /// The color of the text when it is enabled.
    private(set) public var textEnabledColor: UIColor
    /// The color of the text when it is disabled
    private(set) public var textDisabledColor: UIColor
    /// The color of the text when it is highlighted (pressed).
    private(set) public var textHighlightedColor: UIColor
    /// The color of the text when it is selected
    private(set) public var textSelectedColor: UIColor
    /// The height of the cell if the calendar is set up to have a dynamic height.
    private(set) public var heightForDynamicHeightRows: CGFloat
    
    public init(textStyle: ViewPlacement, circleSizeOffset: CGFloat?, font: UIFont, backgroundColor: UIColor, disabledBackgroundColor: UIColor, highlightColor: UIColor, textEnabledColor: UIColor, textDisabledColor: UIColor, textHighlightedColor: UIColor, textSelectedColor: UIColor, heightForDynamicHeightRows: CGFloat) {
        self.textStyle = textStyle
        self.circleSizeOffset = circleSizeOffset
        self.font = font
        self.backgroundColor = backgroundColor
        self.disabledBackgroundColor = disabledBackgroundColor
        self.highlightColor = highlightColor
        self.textEnabledColor = textEnabledColor
        self.textDisabledColor = textDisabledColor
        self.textHighlightedColor = textHighlightedColor
        self.textSelectedColor = textSelectedColor
        self.heightForDynamicHeightRows = heightForDynamicHeightRows
    }
}

/**
 The configuration for the headers
 */
public struct HeaderConfiguration {
    
    /// The font for the header text.
    private(set) public var font: UIFont
    /// The color of the header text.
    private(set) public var textColor: UIColor
    /// The background color of the header
    private(set) public var backgroundColor: UIColor
    /// The height of the header
    private(set) public var height: CGFloat
    
    public init(font: UIFont, textColor: UIColor, backgroundColor: UIColor, height: CGFloat) {
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.height = height
    }
    
}

/**
 Configuration settings that pertain to the logic of enabling and disabling dates.
 */
public struct CalendarLogicConfiguration {
    
    /// Specifies the minimum date to be enabled.
    private(set) public var minDate: Date?
    /// Specifies the maximum date to be enabled.
    private(set) public var maxDate: Date?
    /// Specifies any dates within the <code>minDate</code> and <code>maxDate</code> that should also be disabled.
    private(set) public var disabledDates: [Date]?
    /// Specifies if weekends should be disabled. Default is false.
    private(set) public var shouldDisableWeekends = false
    
    public init(minDate: Date? = nil, maxDate: Date? = nil, disabledDates: [Date]? = nil, disableWeekends: Bool = false) {
        self.minDate = minDate
        self.maxDate = maxDate
        self.disabledDates = disabledDates
        self.shouldDisableWeekends = disableWeekends
    }
    
}

public struct CalendarConfiguration {

    /// Specifies the display style for this calendar.
    private(set) public var displayStyle: DisplayStyle
    /// Specifies the format that a month label should use to display the month. i.e. "MMMM yyyy".
    private(set) public var monthFormat: String
    /// Specifies the background color of the calendar.
    private(set) public var backgroundColor: UIColor
    /// Specifies if the calendar has dynamic height. If false, the calendar's date cells will size themselves appropriately to fit the full month within the view.
    private(set) public var dynamicHeight: Bool
    /// Specifies the space that is between each row and each column on the calendar.
    private(set) public var spaceBetweenDates: CGFloat
    
    /// Specifies date specific configuration settings.
    private(set) public var dateCellConfiguration: DateCellConfiguration
    /// Specifies configuration settings specific to the month header.
    private(set) public var monthHeaderConfiguration: HeaderConfiguration
    /// Specifies configuration settings specific to the weekday header.
    private(set) public var weekdayHeaderConfiguration: HeaderConfiguration
    
    /// Specifies calendar logic for enabling and disabling dates
    private(set) public var logicConfiguration: CalendarLogicConfiguration?
    
    public static func FullScreenConfiguration() -> CalendarConfiguration {
        let dateCellConfiguration = DateCellConfiguration(textStyle: .topCenter(verticalOffset: 17), circleSizeOffset: nil, font: UIFont.preferredDateFont(), backgroundColor: CalendarDesignKit.dateBackgroundColor, disabledBackgroundColor: CalendarDesignKit.calendarDisabledDateColor, highlightColor: CalendarDesignKit.calendarDateColor, textEnabledColor: UIColor.black(), textDisabledColor: UIColor.white().withAlphaComponent(0.6), textHighlightedColor: UIColor.black().withAlphaComponent(0.3), textSelectedColor: UIColor.white(), heightForDynamicHeightRows: 0.0)
        let monthHeaderConfig = HeaderConfiguration(font: UIFont.preferredMonthHeaderFont(), textColor: UIColor.white(), backgroundColor: CalendarDesignKit.calendarDateColor, height: 50.0)
        let weekdayHeaderConfig = HeaderConfiguration(font: UIFont.preferredWeekdayHeaderFont(), textColor: UIColor.white(), backgroundColor: UIColor.lightGray(), height: 30)
        
        return CalendarConfiguration(displayStyle: .fullScreen, monthFormat: "MMMM", calendarBackgroundColor: CalendarDesignKit.calendarBackgroundColor, hasDynamicHeight: false, spaceBetweenDates: 2.0, monthHeaderConfiguration: monthHeaderConfig, weekdayHeaderConfiguration: weekdayHeaderConfig, dateCellConfiguration: dateCellConfiguration)
    }
    
    public static func InputViewConfiguration() -> CalendarConfiguration {
        let dateCellConfiguration = DateCellConfiguration(textStyle: .centerCenter, circleSizeOffset: 8, font: UIFont.preferredInputViewDateFont(), backgroundColor: CalendarDesignKit.dateBackgroundColor, disabledBackgroundColor: CalendarDesignKit.calendarDisabledDateColor, highlightColor: CalendarDesignKit.calendarDateColor, textEnabledColor: UIColor.black(), textDisabledColor: UIColor.white().withAlphaComponent(0.6), textHighlightedColor: UIColor.black().withAlphaComponent(0.3), textSelectedColor: UIColor.white(), heightForDynamicHeightRows: 0.0)
        let monthHeaderConfig = HeaderConfiguration(font: UIFont.preferredInputViewMonthHeaderFont(), textColor: UIColor.white(), backgroundColor: CalendarDesignKit.calendarDateColor, height: 25.0)
        let weekdayHeaderConfig = HeaderConfiguration(font: UIFont.preferredInputViewWeekdayHeaderFont(), textColor: UIColor.white(), backgroundColor: UIColor.lightGray(), height: 15.0)
        
        return CalendarConfiguration(displayStyle: .inputView, monthFormat: "MMMM", calendarBackgroundColor: CalendarDesignKit.calendarBackgroundColor, hasDynamicHeight: false, spaceBetweenDates: 2.0, monthHeaderConfiguration: monthHeaderConfig, weekdayHeaderConfiguration: weekdayHeaderConfig, dateCellConfiguration: dateCellConfiguration)
    }
    
    /**
     Initializer to setup the configuration.
    */
    public init(displayStyle: DisplayStyle, monthFormat: String, calendarBackgroundColor: UIColor, hasDynamicHeight: Bool, spaceBetweenDates: CGFloat, monthHeaderConfiguration: HeaderConfiguration, weekdayHeaderConfiguration: HeaderConfiguration, dateCellConfiguration: DateCellConfiguration, logicConfiguration: CalendarLogicConfiguration? = nil) {
        
        self.displayStyle = displayStyle
        self.monthFormat = monthFormat
        self.dynamicHeight = hasDynamicHeight
        self.spaceBetweenDates = spaceBetweenDates
        self.backgroundColor = calendarBackgroundColor
        self.dateCellConfiguration = dateCellConfiguration
        self.monthHeaderConfiguration = monthHeaderConfiguration
        self.weekdayHeaderConfiguration = weekdayHeaderConfiguration
        self.logicConfiguration = logicConfiguration
    }
    
}
