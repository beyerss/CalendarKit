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
 
 *FullScreen: Use when showing the calendar as a popover (default).
 *PartialScreen: Use when the calendar is going to be displayed in a subview of the containing UIViewController
 *InputView: Use when presenting the calendar as the inputView of a UITextField.
 */
public enum DisplayStyle {
    case FullScreen
    case PartialScreen
    case InputView
}

/**
 The styles available for the date cells. These options are the styles available for placement of the date text in a cell
 
 *Top: Puts the date text near the top of the cell at a constant distance from the top and centered horizontally
 *Center: Puts the date text centered vertically and horizontally
 */
public enum DateCellStyle {
    case Top
    case Center
}

public struct CalendarConfiguration {

    public var displayStyle: DisplayStyle = .FullScreen
    public var dateTextStyle: DateCellStyle = .Top
    
    public init() {
        // Nothing needs to be done here
    }
    
}
