//
//  TwitDataSource.swift
//  Tweeter
//
//  Created by Andrew James on 2/14/15.
//  Copyright (c) 2015 Andrew James. All rights reserved.
//

import Foundation
import UIKit

class Twit: NSObject, NSCoding
{
    let text: String
    let date: NSDate

    init(text:String, date:NSDate)
    {
        self.text = text
        self.date = date
    }

    required init(coder aDecoder: NSCoder)
    {
        self.text = aDecoder.decodeObjectForKey("text") as String
        self.date = aDecoder.decodeObjectForKey("date") as NSDate
    }

    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(self.text, forKey: "text")
        aCoder.encodeObject(self.date, forKey: "date")
    }

}


class TwitDataSource
{
    private var twitStore = [Twit]()

    var twits: [Twit]
    {
        if User.currentUser == nil
        {
            twitStore = []
        }
        return twitStore
    }

    init()
    {
        FakeTweeterServer.load()
    }

    func fetchNewTwits(completion:(newTwitsFound:Bool, error:NSError?)->())
    {
        GCDDispatchAsyncHigh {
            var foundNewTwits = false
            if let username = User.currentUser
            {
                //simulate network latency
                NSThread.sleepForTimeInterval(1)
                //fetch new twits
                let initialCount = self.twitStore.count
                self.twitStore = FakeTweeterServer.fetchTwitsForUser(username)
                foundNewTwits = (initialCount < self.twitStore.count)
            }
            completion(newTwitsFound:foundNewTwits, error: nil)
        }
    }

    func sendTwit(newTwit:String, completion:(error:NSError?)->())
    {
        GCDDispatchAsyncHigh {
            //simulate network latency
            NSThread.sleepForTimeInterval(1)
            //save twit
            let twit = Twit(text: newTwit, date: NSDate())
            FakeTweeterServer.saveTwitForUser(User.currentUser!, twit: twit)
            completion(error: nil)
        }
    }

}


let twit1 = Twit(text: "Testing, 1...,2...,3...", date: NSDate() )
let twit2 = Twit(text: "Is this thing on?", date: NSDate() )
let twit3 = Twit(text: "This is a really, really, really long text. Word wrapping is expected.", date: NSDate() )
let defaultData = [twit1, twit2, twit3]
var remoteStore = [String:[Twit]]()

class FakeTweeterServer
{
    class func fetchTwitsForUser(username:String) -> [Twit]
    {
        // if there is data in the fake store, use it
        if let remoteTwits = remoteStore[username]
        {
            return remoteTwits
        }
        else // otherwise, store a copy from defaults, and use it
        {
            remoteStore[username] = Array(defaultData)
            save()
            return remoteStore[username]!
        }
    }

    class func saveTwitForUser(username:String, twit:Twit)
    {
        var twits = FakeTweeterServer.fetchTwitsForUser(username)
        twits.append(twit)
        remoteStore[username] = twits
        save()
    }


    class func save()
    {
        var path = dataPath
        NSKeyedArchiver.archiveRootObject(remoteStore, toFile: dataPath)
    }

    class func load()
    {
        if let dictionary = NSKeyedUnarchiver.unarchiveObjectWithFile(dataPath) as? [String:[Twit]]
        {
            remoteStore = dictionary
        }
        else
        {
            remoteStore = [String:[Twit]]()
        }
    }

    class var dataPath: String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory: String = paths[0] as String
        let path = documentsDirectory.stringByAppendingPathComponent("data.plist")
        return path
    }

}
