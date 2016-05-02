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
    case TopCenter(verticalOffset: Int)
    // Puts the date text near the top-left of the cell at a constant distance from the top and a constant distance from the left.
    case TopLeft(verticalOffset: Int, horizontalOffset: Int)
    // Puts the date text near the top-right of the cell at a constant distance from the top and a constant distance from the right.
    case TopRight(verticalOffset: Int, horizontalOffset: Int)
    // Puts the date text centered vertically and horizontally in the date cell.
    case CenterCenter
    // Puts the date text near the left of the cell centered vertically and a constant distance from the left.
    case CenterLeft(horizontalOffset: Int)
    // Puts the date text near the right of the cell centered vertically and a constant distance from the right.
    case CenterRight(horizontalOffset: Int)
    // Puts the date text near the bottom of the cell at a constant distance from the bottom and centered horizontally.
    case BottomCenter(verticalOffset: Int)
    // Puts the date text near the bottom-left of the cell at a constant distance from the bottom and a constant distance from the left.
    case BottomLeft(verticalOffset: Int, horizontalOffset: Int)
    // Puts the date text near the bottom-right of the cell at a constant distance from the bottom and a constant distance from the right.
    case BottomRight(verticalOffset: Int, horizontalOffset: Int)
}

public struct CalendarConfiguration {

    var displayStyle: DisplayStyle
    var dateTextStyle: DateCellStyle
    
    public static func FullScreenConfiguration() -> CalendarConfiguration {
        return CalendarConfiguration(displayStyle: .FullScreen, dateTextStyle: .TopCenter(verticalOffset: 17))
    }
    
    public static func InputViewConfiguration() -> CalendarConfiguration {
        return CalendarConfiguration(displayStyle: .InputView, dateTextStyle: .CenterCenter)
    }
    
    /**
     Initializer to setup the configuration.
    */
    public init(displayStyle: DisplayStyle, dateTextStyle: DateCellStyle) {
        self.displayStyle = displayStyle
        self.dateTextStyle = dateTextStyle
    }
    
}
