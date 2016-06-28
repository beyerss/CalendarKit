//
//  SpacerCollectionViewCellTests.swift
//  CalendarKit
//
//  Created by Steven Beyers on 6/28/16.
//  Copyright © 2016 Beyers Apps, LLC. All rights reserved.
//

import XCTest
@testable import CalendarKit

class SpacerCollectionViewCellTests: XCTestCase {
    
    let cell = SpacerCollectionViewCell()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAwakeFromNib() {
        cell.awakeFromNib()
        
        XCTAssertNotNil(cell)
    }
    
}
