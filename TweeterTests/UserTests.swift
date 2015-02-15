//
//  TweeterTests.swift
//  TweeterTests
//
//  Created by Andrew James on 2/13/15.
//  Copyright (c) 2015 Andrew James. All rights reserved.
//

import UIKit
import XCTest

class UserTests: AsyncTestCase
{
    
    func testGetMockUser()
    {
        User.signout()
        var username: String?
        var error: NSError?
        
        User.signIn("user", password: "pass") { user, err in
            username = user
            error = err
            self.fulfill()
        }
        wait()

        XCTAssertNil(error)
        XCTAssert(username == "user")
        XCTAssert(User.currentUser == "user")

        User.signout()
        XCTAssert(User.currentUser == nil)
    }

    func testUnknownUser()
    {
        User.signout()
        var username: String?
        var error: NSError?

        User.signIn("baduser", password: "pass") { user, err in
            username = user
            error = err
            self.fulfill()
        }
        wait()

        XCTAssertNotNil(error)
        XCTAssertNil(username)
    }

}
