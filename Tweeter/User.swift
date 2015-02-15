//
//  User.swift
//  Tweeter
//
//  Created by Andrew James on 2/13/15.
//  Copyright (c) 2015 Andrew James. All rights reserved.
//

import Foundation

let kUsername = "username"

class User
{

    class func signIn(username:String, password:String, completion:(username:String?,error:NSError?)->())
    {
        GCDDispatchAsyncHigh { () -> () in
            var theUser: String?
            var theError: NSError?
            //simulate network latency
            NSThread.sleepForTimeInterval(1)
            if username.lowercaseString.hasPrefix("bad")
            {
                theError = NSError(domain: "unknown user", code: 0, userInfo: nil)
            }
            else
            {
                theUser = username
            }
            User.currentUser = theUser
            completion(username: theUser, error: theError)

        }
    }

    class func signout()
    {
        User.currentUser = nil
    }


    class var currentUser: String?
    {
        get
        {
            return NSUserDefaults.standardUserDefaults().stringForKey(kUsername)
        }
        set
        {
            if newValue == nil
            {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(kUsername)
            }
            else
            {
                NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: kUsername)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

}