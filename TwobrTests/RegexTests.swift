//
//  RegexTests.swift
//  Twobr
//
//  Created by Jim Schultz on 2/23/15.
//  Copyright (c) 2015 Blue Boxen, LLC. All rights reserved.
//

import UIKit
import XCTest

class RegexTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            
            let expectation = self.expectationWithDescription("RetrieveRegex")
            
            // Put the code you want to measure the time of here.
            let jobVC = JobsViewController()
            jobVC.retrieveRegex({
                expectation.fulfill()
                }, failure: {
                    XCTAssertNil("failed to get regex")
            })
            
            self.waitForExpectationsWithTimeout(10, handler: { (error) -> Void in
                XCTAssertNil(error)
            })
        }
    }

}
