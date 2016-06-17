//
//  CalendarConfigurationTests.swift
//  CalendarKit
//
//  Created by Steven Beyers on 6/17/16.
//  Copyright © 2016 Beyers Apps, LLC. All rights reserved.
//

import XCTest
@testable import CalendarKit

class CalendarConfigurationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCustomDateCellConfiguration() {
        let textStyle = ViewPlacement.TopCenter(verticalOffset: 8)
        let weekdayHeaderColor = UIColor(red: 157/255, green: 56/255, blue: 155/255, alpha: 1.0)
        let circleSizeOffset: CGFloat = -7
        let font = UIFont(name: "AmericanTypewriter-Bold", size: 10)!
        let backgroundColor = UIColor.whiteColor()
        let disabledBackgroundColor = UIColor.darkGrayColor()
        let highlightColor = UIColor(red: 158/255, green: 56/255, blue: 155/255, alpha: 1.0)
        let textEnabledColor = UIColor(red: 158/255, green: 56/255, blue: 1/255, alpha: 1.0)
        let textDisabledColor = UIColor.lightGrayColor()
        let textHighlightColor = weekdayHeaderColor.colorWithAlphaComponent(0.6)
        let textSelectedColor = UIColor.whiteColor()
        let heightForDynamicHeightRows: CGFloat = 40.0
        
        let dateCellConfiguration = DateCellConfiguration(textStyle: textStyle, circleSizeOffset: circleSizeOffset, font: font, backgroundColor: backgroundColor, disabledBackgroundColor: disabledBackgroundColor, highlightColor: highlightColor, textEnabledColor: textEnabledColor, textDisabledColor: textDisabledColor, textHighlightedColor: textHighlightColor, textSelectedColor: textSelectedColor, heightForDynamicHeightRows: heightForDynamicHeightRows)
        
        switch textStyle {
        case .TopCenter(verticalOffset: let offset):
            switch dateCellConfiguration.textStyle {
            case .TopCenter(verticalOffset: let configOffset):
                XCTAssertTrue(offset == configOffset, "Text style was not set properly")
            default:
                XCTFail("Text style was not set properly")
            }
        default:
            XCTFail("Text style was not set properly")
        }
        
        XCTAssertTrue(circleSizeOffset == dateCellConfiguration.circleSizeOffset, "CircleSizeOffset was not set properly")
        XCTAssertTrue(font == dateCellConfiguration.font, "Font was not set properly")
        XCTAssertTrue(backgroundColor == dateCellConfiguration.backgroundColor, "BackgroundColor was not set properly")
        XCTAssertTrue(disabledBackgroundColor == dateCellConfiguration.disabledBackgroundColor, "DisabledBackgroundColor was not set properly")
        XCTAssertTrue(highlightColor == dateCellConfiguration.highlightColor, "HighlightColor was not set properly")
        XCTAssertTrue(textEnabledColor == dateCellConfiguration.textEnabledColor, "TextEnabledColor was not set properly")
        XCTAssertTrue(textDisabledColor == dateCellConfiguration.textDisabledColor, "TextDisabledColor was not set properly")
        XCTAssertTrue(textHighlightColor == dateCellConfiguration.textHighlightedColor, "TextHighlightColor was not set properly")
        XCTAssertTrue(textSelectedColor == dateCellConfiguration.textSelectedColor, "TextSelectedColor was not set properly")
        XCTAssertTrue(heightForDynamicHeightRows == dateCellConfiguration.heightForDynamicHeightRows, "HeightForDynamicHeightRows was not set properly")
    }
    
    func testCustomHeaderConfiguration() {
        let font = UIFont(name: "AmericanTypewriter", size: 13)!
        let textColor = UIColor.lightGrayColor()
        let backgroundColor = UIColor.redColor()
        let height: CGFloat = 20
        
        let headerConfig = HeaderConfiguration(font: font, textColor: textColor, backgroundColor: backgroundColor, height: height)
        
        XCTAssertTrue(font == headerConfig.font, "Font was not set properly")
        XCTAssertTrue(textColor == headerConfig.textColor, "TextColor was not set properly")
        XCTAssertTrue(backgroundColor == headerConfig.backgroundColor, "BackgroundColor was not set properly")
        XCTAssertTrue(height == headerConfig.height, "Height was not set properly")
    }
    
    func testCustomCalendarLogicConfiguration() {
        let minDate = NSDate()
        let maxDate = NSDate().dateByAddingTimeInterval(60 * 60 * 24 * 31)
        let disabledDates: [NSDate] = [NSDate().dateByAddingTimeInterval(60 * 60 * 24 * 2), NSDate().dateByAddingTimeInterval(60 * 60 * 24 * 7), NSDate().dateByAddingTimeInterval(60 * 60 * 24 * 8)]
        let disableWeekends = true
        
        let logicConfig = CalendarLogicConfiguration(minDate: minDate, maxDate: maxDate, disabledDates: disabledDates, disableWeekends: disableWeekends)
        
        XCTAssertTrue(minDate == logicConfig.minDate, "MinDate was not set properly")
        XCTAssertTrue(maxDate == logicConfig.maxDate, "MaxDate was not set properly")
        XCTAssertTrue(disabledDates == logicConfig.disabledDates!, "DisabledDates was not set properly")
        XCTAssertTrue(disableWeekends == logicConfig.shouldDisableWeekends, "ShouldDisableWeekends was not set properly")
    }
    
    func testFullScreenConfigurationHelper() {
        let fullScreenConfig = CalendarConfiguration.FullScreenConfiguration()
        
        XCTAssertTrue(fullScreenConfig.displayStyle == .FullScreen, "FullScreen display style not set")
    }
    
    func testInputViewConfigurationHelper() {
        let inputConfig = CalendarConfiguration.InputViewConfiguration()
        
        XCTAssertTrue(inputConfig.displayStyle == .InputView, "Input display style not set")
    }
    
    func testCustomConfiguration() {
        // Basic setup stuff
        let weekdayHeaderColor = UIColor(red: 157/255, green: 56/255, blue: 155/255, alpha: 1.0)
        let dateCellConfiguration = DateCellConfiguration(textStyle: .TopCenter(verticalOffset: 8), circleSizeOffset: -7, font: UIFont(name: "AmericanTypewriter-Bold", size: 10)!, backgroundColor: UIColor.whiteColor(), disabledBackgroundColor: UIColor.darkGrayColor(), highlightColor: weekdayHeaderColor, textEnabledColor: weekdayHeaderColor, textDisabledColor: UIColor.lightGrayColor(), textHighlightedColor: weekdayHeaderColor.colorWithAlphaComponent(0.6), textSelectedColor: UIColor.whiteColor(), heightForDynamicHeightRows: 40.0)
        let monthHeaderConfig = HeaderConfiguration(font: UIFont(name: "AmericanTypewriter-Bold", size: 30)!, textColor: UIColor.lightGrayColor(), backgroundColor: UIColor.purpleColor(), height: 40.0)
        let weekdayHeaderConfig = HeaderConfiguration(font: UIFont(name: "AmericanTypewriter", size: 13)!, textColor: UIColor.lightGrayColor(), backgroundColor: weekdayHeaderColor, height: 20.0)
        let disabledDates: [NSDate] = [NSDate().dateByAddingTimeInterval(60 * 60 * 24 * 2), NSDate().dateByAddingTimeInterval(60 * 60 * 24 * 7), NSDate().dateByAddingTimeInterval(60 * 60 * 24 * 8)]
        let logicConfig = CalendarLogicConfiguration(minDate: NSDate(), maxDate: NSDate().dateByAddingTimeInterval(60 * 60 * 24 * 31), disabledDates: disabledDates, disableWeekends: false)
        
        // Testable configuration values
        let displayStyle = DisplayStyle.Custom
        let monthFormat = "MMMM yyyy"
        let backgroundColor = UIColor.greenColor()
        let hasDynamicHeight = true
        let space: CGFloat = 4.0
        
        let config = CalendarConfiguration(displayStyle: displayStyle, monthFormat: monthFormat, calendarBackgroundColor: backgroundColor, hasDynamicHeight: hasDynamicHeight, spaceBetweenDates: space, monthHeaderConfiguration: monthHeaderConfig, weekdayHeaderConfiguration: weekdayHeaderConfig, dateCellConfiguration: dateCellConfiguration, logicConfiguration: logicConfig)
        
        XCTAssertTrue(displayStyle == config.displayStyle, "DisplayStyle not set properly")
        XCTAssertTrue(monthFormat == config.monthFormat, "MonthFormat not set properly")
        XCTAssertTrue(backgroundColor == config.backgroundColor, "BackgroundColor not set properly")
        XCTAssertTrue(hasDynamicHeight == config.dynamicHeight, "DynamicHeight not set properly")
        XCTAssertTrue(space == config.spaceBetweenDates, "SpaceBetweenDates not set properly")
    }
    
}
