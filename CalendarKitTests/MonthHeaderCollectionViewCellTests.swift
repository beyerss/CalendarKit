//
//  MonthHeaderCollectionViewCellTests.swift
//  CalendarKit
//
//  Created by Steven Beyers on 6/28/16.
//  Copyright © 2016 Beyers Apps, LLC. All rights reserved.
//

import XCTest
@testable import CalendarKit

class MonthHeaderCollectionViewCellTests: XCTestCase {
    
    let monthCell = MonthHeaderCollectionViewCell()
    let monthLabel = UILabel()
    
    override func setUp() {
        super.setUp()
        
        monthCell.monthName = monthLabel
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAwakeFromNib() {
        monthCell.awakeFromNib()
        
        XCTAssertTrue(monthCell.monthName.font == UIFont.preferredMonthHeaderFont(), "Font is not correct")
    }
}
