//
//  User.swift
//  Tweeter
//
//  Created by Andrew James on 2/13/15.
//  Copyright (c) 2015 Andrew James. All rights reserved.
//

import Foundation

let kUsername = "username"

class User {
 
    class func signIn(username: String, password: String, completion: @escaping (_ username: String?, _ error: NSError?)->()) {
        GCDDispatchAsyncHigh { () -> () in
            var theUser: String?
            var theError: NSError?
            //simulate network latency
            Thread.sleep(forTimeInterval: 1)
            if username.lowercased().hasPrefix("bad") {
                theError = NSError(domain: "unknown user", code: 0, userInfo: nil)
            } else {
                theUser = username
            }
            User.currentUser = theUser
            completion(theUser, theError)
        }
    }

    class func signout()
    {
        User.currentUser = nil
    }

    class var currentUser: String?
    {
        get {
            return UserDefaults.standard.string(forKey: kUsername)
        } set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: kUsername)
            } else {
                UserDefaults.standard.set(newValue, forKey: kUsername)
            }
            UserDefaults.standard.synchronize()
        }
    }
}
