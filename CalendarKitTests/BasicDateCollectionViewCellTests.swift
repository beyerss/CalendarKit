//
//  BasicDateCollectionViewCellTests.swift
//  CalendarKit
//
//  Created by Steven Beyers on 6/28/16.
//  Copyright © 2016 Beyers Apps, LLC. All rights reserved.
//

import XCTest
@testable import CalendarKit

class BasicDateCollectionViewCellTests: XCTestCase {
    
    let basicDateCell = BasicDateCollectionViewCell()
    let dateLabel = UILabel()
    
    override func setUp() {
        super.setUp()
        
        basicDateCell.dateLabel = dateLabel
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetHighlightedTrue() {
        basicDateCell.highlighted = true
        
        XCTAssertTrue(basicDateCell.dateLabel.textColor == basicDateCell.highlightedTextColor, "Text color has not been set properly")
    }
    
    func testSetHighlightedFalse() {
        basicDateCell.highlighted = false
        
        XCTAssertTrue(basicDateCell.dateLabel.textColor == basicDateCell.enabledTextColor, "Text color has not been set properly")
    }
    
    func testStyleTodayNotWeekendNotSelectedNotDisabled() {
        let config = CalendarConfiguration.FullScreenConfiguration()
        let font = UIFont(name: "AmericanTypewriter", size: 13)!
        
        basicDateCell.highlighted = false
        basicDateCell.style(dateIsToday: true, dateIsWeekend: false, dateIsSelected: false, disabled: false, textPlacement: ViewPlacement.BottomCenter(verticalOffset: 5), font: font, circleSizeOffset: 3, calendarConfiguration: config, accessory: nil)
        
        // This just make sure there is no crash
        basicDateCell.drawRect(CGRectMake(0, 0, 320, 40))
        
        XCTAssertTrue(basicDateCell.backgroundColor == config.dateCellConfiguration.backgroundColor, "Incorect background color")
        XCTAssertTrue(basicDateCell.dateLabel.textColor == basicDateCell.enabledTextColor, "Text color has not been set properly")
        XCTAssertTrue(basicDateCell.dateLabel.font == font, "Date label font is not correct")
    }
    
    func testStyleTodayWeekendSelectedNotDisabled() {
        let config = CalendarConfiguration.FullScreenConfiguration()
        let font = UIFont(name: "AmericanTypewriter", size: 13)!
        
        basicDateCell.highlighted = false
        basicDateCell.style(dateIsToday: true, dateIsWeekend: false, dateIsSelected: true, disabled: false, textPlacement: ViewPlacement.BottomLeft(verticalOffset: 5, horizontalOffset: 2), font: font, circleSizeOffset: 3, calendarConfiguration: config, accessory: nil)
        
        basicDateCell.circleColor = UIColor.orangeColor()
        // This just make sure there is no crash
        basicDateCell.drawRect(CGRectMake(0, 0, 320, 40))
        
        XCTAssertTrue(basicDateCell.backgroundColor == config.dateCellConfiguration.backgroundColor, "Incorect background color")
        XCTAssertTrue(basicDateCell.dateLabel.textColor == basicDateCell.selectedTextColor, "Text color has not been set properly")
        XCTAssertTrue(basicDateCell.dateLabel.font == font, "Date label font is not correct")
    }
    
    func testStyleTodayWeekendSelectedDisabled() {
        let config = CalendarConfiguration.FullScreenConfiguration()
        let font = UIFont(name: "AmericanTypewriter", size: 13)!
        
        basicDateCell.highlighted = false
        basicDateCell.style(dateIsToday: true, dateIsWeekend: false, dateIsSelected: true, disabled: true, textPlacement: ViewPlacement.BottomRight(verticalOffset: 5, horizontalOffset: 2), font: font, circleSizeOffset: 3, calendarConfiguration: config, accessory: nil)
        
        basicDateCell.circleColor = nil
        // This just make sure there is no crash
        basicDateCell.drawRect(CGRectMake(0, 0, 320, 40))
        
        XCTAssertTrue(basicDateCell.backgroundColor == config.dateCellConfiguration.disabledBackgroundColor, "Incorect background color")
        XCTAssertTrue(basicDateCell.dateLabel.textColor == basicDateCell.disabledTextColor, "Text color has not been set properly")
        XCTAssertTrue(basicDateCell.dateLabel.font == font, "Date label font is not correct")
    }
    
    func testStyleTodayWeekendNotSelectedDisabled() {
        let config = CalendarConfiguration.FullScreenConfiguration()
        let font = UIFont(name: "AmericanTypewriter", size: 13)!
        
        basicDateCell.highlighted = false
        basicDateCell.style(dateIsToday: true, dateIsWeekend: false, dateIsSelected: false, disabled: true, textPlacement: ViewPlacement.TopCenter(verticalOffset: 5), font: font, circleSizeOffset: 3, calendarConfiguration: config, accessory: nil)
        
        basicDateCell.circleColor = UIColor.orangeColor()
        // This just make sure there is no crash
        basicDateCell.drawRect(CGRectMake(0, 0, 320, 40))
        
        XCTAssertTrue(basicDateCell.backgroundColor == config.dateCellConfiguration.disabledBackgroundColor, "Incorect background color")
        XCTAssertTrue(basicDateCell.dateLabel.textColor == basicDateCell.disabledTextColor, "Text color has not been set properly")
        XCTAssertTrue(basicDateCell.dateLabel.font == font, "Date label font is not correct")
    }
    
    func testPrepareForReuse() {
        basicDateCell.prepareForReuse()
        
        XCTAssertNil(basicDateCell.accessory, "Accessory should now be nil")
        XCTAssertTrue(basicDateCell.dateLabel.textColor == basicDateCell.enabledTextColor, "Text color has not been set properly")
    }
    
    func testPrepareForReuseRemovingAccessory() {
        let config = CalendarConfiguration.FullScreenConfiguration()
        let font = UIFont(name: "AmericanTypewriter", size: 13)!
        let accessory = CalendarAccessory(placement: .TopRight(verticalOffset: 5, horizontalOffset: 2), view: UIView())
        
        basicDateCell.highlighted = false
        basicDateCell.style(dateIsToday: true, dateIsWeekend: false, dateIsSelected: false, disabled: true, textPlacement: ViewPlacement.CenterCenter, font: font, circleSizeOffset: 3, calendarConfiguration: config, accessory: accessory)
        
        basicDateCell.prepareForReuse()
        
        XCTAssertNil(basicDateCell.accessory, "Accessory should now be nil")
        XCTAssertTrue(basicDateCell.dateLabel.textColor == basicDateCell.enabledTextColor, "Text color has not been set properly")
    }
    
    func testAwakeFromNib() {
        basicDateCell.awakeFromNib()
        
        XCTAssertTrue(basicDateCell.backgroundColor == CalendarDesignKit.dateBackgroundColor, "Incorect background color")
    }
    
    func testStyleNoConfigDisabled() {
        let font = UIFont(name: "AmericanTypewriter", size: 13)!
        
        basicDateCell.highlighted = false
        basicDateCell.style(dateIsToday: true, dateIsWeekend: false, dateIsSelected: true, disabled: true, textPlacement: ViewPlacement.CenterRight(horizontalOffset: 2), font: font, circleSizeOffset: 3, calendarConfiguration: nil, accessory: nil)
        
        XCTAssertTrue(basicDateCell.backgroundColor == CalendarDesignKit.calendarDisabledDateColor, "Incorect background color")
        XCTAssertTrue(basicDateCell.dateLabel.textColor == basicDateCell.disabledTextColor, "Text color has not been set properly")
        XCTAssertTrue(basicDateCell.dateLabel.font == font, "Date label font is not correct")
    }
    
    func testStyleNoConfigNotDisabled() {
        let font = UIFont(name: "AmericanTypewriter", size: 13)!
        
        basicDateCell.highlighted = false
        basicDateCell.style(dateIsToday: true, dateIsWeekend: false, dateIsSelected: true, disabled: false, textPlacement: ViewPlacement.CenterLeft(horizontalOffset: 2), font: font, circleSizeOffset: 3, calendarConfiguration: nil, accessory: nil)
        
        XCTAssertTrue(basicDateCell.backgroundColor == CalendarDesignKit.dateBackgroundColor, "Incorect background color")
        XCTAssertTrue(basicDateCell.dateLabel.textColor == basicDateCell.selectedTextColor, "Text color has not been set properly")
        XCTAssertTrue(basicDateCell.dateLabel.font == font, "Date label font is not correct")
    }
    
    func testStyleChangingViewPlacement() {
        let config = CalendarConfiguration.FullScreenConfiguration()
        let font = UIFont(name: "AmericanTypewriter", size: 13)!
        
        basicDateCell.highlighted = false
        basicDateCell.style(dateIsToday: true, dateIsWeekend: false, dateIsSelected: true, disabled: true, textPlacement: ViewPlacement.TopLeft(verticalOffset: 5, horizontalOffset: 2), font: font, circleSizeOffset: 3, calendarConfiguration: nil, accessory: nil)
        basicDateCell.style(dateIsToday: true, dateIsWeekend: false, dateIsSelected: true, disabled: false, textPlacement: ViewPlacement.TopRight(verticalOffset: 5, horizontalOffset: 2), font: font, circleSizeOffset: 3, calendarConfiguration: config, accessory: nil)
        
        XCTAssertTrue(basicDateCell.backgroundColor == CalendarDesignKit.dateBackgroundColor, "Incorect background color")
        XCTAssertTrue(basicDateCell.dateLabel.textColor == basicDateCell.selectedTextColor, "Text color has not been set properly")
        XCTAssertTrue(basicDateCell.dateLabel.font == font, "Date label font is not correct")
    }
    
}
