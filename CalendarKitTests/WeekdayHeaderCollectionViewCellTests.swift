//
//  WeekdayHeaderCollectionViewCellTests.swift
//  CalendarKit
//
//  Created by Steven Beyers on 6/28/16.
//  Copyright © 2016 Beyers Apps, LLC. All rights reserved.
//

import XCTest
@testable import CalendarKit

class WeekdayHeaderCollectionViewCellTests: XCTestCase {
    
    let headerCell = WeekdayHeaderCollectionViewCell()
    let label = UILabel()
    
    override func setUp() {
        super.setUp()
        
        headerCell.dayNameLabel = label
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAwakeFromNib() {
        headerCell.awakeFromNib()
        
        XCTAssertTrue(headerCell.dayNameLabel.font == UIFont.preferredWeekdayHeaderFont(), "Font is not correct")
    }
    
}
