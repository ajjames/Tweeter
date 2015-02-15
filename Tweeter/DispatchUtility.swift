//
//  DispatchUtility.swift
//  Tweeter
//
//  Created by Andrew James on 2/13/15.
//  Copyright (c) 2015 Andrew James. All rights reserved.
//

import Foundation

func GCDDispatchMain(closure:()->())
{
    dispatch_async(dispatch_get_main_queue(), closure)
}

func GCDDispatchAsyncHigh(closure: ()->())
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), closure)
}

func GCDDispatchAsyncDefault(closure: ()->())
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), closure)
}

func GCDDispatchAsyncLow(closure: ()->())
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), closure)
}

func GCDDispatchAsyncBackground(closure: ()->())
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), closure)
}
