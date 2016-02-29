//
//  Program.swift
//  EPG
//
//  Created by Adnan Aftab on 2/14/15.
//  Copyright (c) 2015 CX. All rights reserved.
//

import UIKit

class Program: NSObject
{
    var name : String?
    var startTime : NSDate?
    var endTime : NSDate?
    var timeString : String
    {
        get
        {
            if(startTime != nil && endTime != nil)
            {
                let dateFormater = NSDateFormatter()
                dateFormater.dateFormat = "h:mma"
                return "\(dateFormater.stringFromDate(startTime!)) - \(dateFormater.stringFromDate(endTime!))"
            }
            return "No info available"
        }
    }
    var duration : NSTimeInterval
    {
        get
        {
            if(startTime != nil && endTime != nil)
            {
                return endTime!.timeIntervalSinceDate(startTime!)
            }
            return 0.0
        }
    }
}
extension Program 
{
    override var description : String
    {
        return "Program name: \(name) startTIme: \(startTime) endTime \(endTime)\n"
    }
    
    override var debugDescription : String
    {
        return "Program name: \(name) startTIme: \(startTime) endTime \(endTime)\n"
    }
}
