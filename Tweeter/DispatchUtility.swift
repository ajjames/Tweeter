//
//  DispatchUtility.swift
//  Tweeter
//
//  Created by Andrew James on 2/13/15.
//  Copyright (c) 2015 Andrew James. All rights reserved.
//

import Foundation

func GCDDispatchMain(closure: @escaping ()->())
{
    DispatchQueue.main.async(execute: closure)
}

func GCDDispatchAsyncHigh(closure: @escaping ()->())
{
    DispatchQueue.global(qos: .userInteractive).async(execute: closure)
}

func GCDDispatchAsyncDefault(closure: @escaping ()->())
{
    DispatchQueue.global(qos: .default).async(execute: closure)
}

func GCDDispatchAsyncLow(closure: @escaping ()->())
{
    DispatchQueue.global(qos: .utility).async(execute: closure)
}

func GCDDispatchAsyncBackground(closure: @escaping ()->())
{
    DispatchQueue.global(qos: .background).async(execute: closure)
}
