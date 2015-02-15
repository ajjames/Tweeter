//
//  Extensions.swift
//  Tweeter
//
//  Created by Andrew James on 2/14/15.
//  Copyright (c) 2015 Andrew James. All rights reserved.
//

import Foundation

extension NSDate
{
    public func toString() -> String
    {
        let df = NSDateFormatter()
        df.dateFormat = "MM-dd-yyyy"
        return df.stringFromDate(self)
    }
}
