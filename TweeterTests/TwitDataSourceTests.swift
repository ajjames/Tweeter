//
//  TwitDataSourceTests.swift
//  Tweeter
//
//  Created by Andrew James on 2/14/15.
//  Copyright (c) 2015 Andrew James. All rights reserved.
//

import UIKit
import XCTest

class TwitDataSourceTests: AsyncTestCase
{

    func testDataSourceInitScenario()
    {
        //NO USER
        User.signout()
        var dataSource = TwitDataSource()
        XCTAssertEqual(dataSource.twits.count, 0)

        //SIGN IN
        User.signIn("user", password: "pass") { user, err in
            self.fulfill()
        }
        wait()
        resetAsyncTest()

        //FETCH TWITS
        var success:Bool?
        dataSource.fetchNewTwits { (newTwitsFound, error) -> () in
            self.fulfill()
            success = newTwitsFound
        }
        wait()

        XCTAssertTrue(success!)
        XCTAssertGreaterThanOrEqual(dataSource.twits.count, 3)
    }

    func testExitingUserInit()
    {
        //SIGN IN
        User.signIn("user", password: "pass") { user, err in
            self.fulfill()
        }
        wait()

        var dataSource = TwitDataSource()
        XCTAssertEqual(dataSource.twits.count, 0)
    }

    func testDataSourceUpdate()
    {
        User.signout()
        var dataSource = TwitDataSource()
        XCTAssertEqual(dataSource.twits.count, 0)

        User.signIn("user", password: "pass") { user, err in
            self.fulfill()
        }
        wait()
        resetAsyncTest()

        XCTAssertEqual(dataSource.twits.count, 0)

        var error:NSError?
        var success:Bool?

        dataSource.fetchNewTwits { (newTwitsFound, err) in
            error = err
            success = newTwitsFound
            self.fulfill()
        }
        wait()

        XCTAssertNil(error)
        XCTAssertTrue(success!)
    }

    func testSaveNewTwit()
    {
        User.signout()
        var dataSource = TwitDataSource()
        XCTAssertEqual(dataSource.twits.count, 0)

        User.signIn("user", password: "pass") { user, err in
            self.fulfill()
        }
        wait()
        resetAsyncTest()

        XCTAssertEqual(dataSource.twits.count, 0)

        //SAVE NEW TWIT
        dataSource.sendTwit("test twit", completion: { (error) -> () in
            self.fulfill()
        })
        wait()
        resetAsyncTest()

        //FETCH TWITS
        var success:Bool?
        dataSource.fetchNewTwits { (newTwitsFound, error) -> () in
            self.fulfill()
            success = newTwitsFound
        }
        wait()

        XCTAssertTrue(success!)
        XCTAssertGreaterThanOrEqual(dataSource.twits.count, 3)
    }

}
