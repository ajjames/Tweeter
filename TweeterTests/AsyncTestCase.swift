//
//  AsyncTestCase.swift
//  Tweeter
//
//  Created by Andrew James on 2/13/15.
//  Copyright (c) 2015 Andrew James. All rights reserved.
//

import Foundation

import UIKit
import XCTest

let kAsyncTimeout = NSTimeInterval(30)

class AsyncTestCase: XCTestCase
{
    var expectation: XCTestExpectation!

    override func setUp()
    {
        super.setUp()
        resetAsyncTest()
    }

    override func tearDown()
    {
        expectation = nil
        super.tearDown()
    }

    func fulfill()
    {
        self.expectation.fulfill()
    }

    func resetAsyncTest()
    {
        expectation = self.expectationWithDescription("async test")
    }

    func wait()
    {
        waitForExpectationsWithTimeout(kAsyncTimeout, handler: { err in
            XCTAssertNil(err)
        })
    }
    
}
