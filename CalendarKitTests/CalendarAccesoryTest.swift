//
//  CalendarAccesoryTest.swift
//  CalendarKit
//
//  Created by Steven Beyers on 6/17/16.
//  Copyright © 2016 Beyers Apps, LLC. All rights reserved.
//

import XCTest
@testable import CalendarKit

class CalendarAccesoryTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCalendarAccessory() {
        let view = UIButton()
        let verticalOffset: CGFloat = 8
        let horizontalOffset: CGFloat = 2
        let placement = ViewPlacement.BottomRight(verticalOffset: verticalOffset, horizontalOffset: horizontalOffset)
        
        let accessory = CalendarAccessory(placement: placement, view: view)
        
        XCTAssertTrue(view == accessory.view, "View was not set properly")
        
        switch accessory.placement {
        case .BottomRight(verticalOffset: let v, horizontalOffset: let h):
            XCTAssertTrue(v == verticalOffset, "Vertical Offset not set properly")
            XCTAssertTrue(h == horizontalOffset, "Horizontal Offset not set properly")
        default:
            XCTFail("Placement not set proplerly")
        }
    }
    
}
