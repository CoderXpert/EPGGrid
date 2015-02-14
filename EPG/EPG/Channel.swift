//
//  Channel.swift
//  EPG
//
//  Created by Adnan Aftab on 2/14/15.
//  Copyright (c) 2015 CX. All rights reserved.
//

import UIKit

class Channel: NSObject
{
    var channelNumber:String?
    var channelName:String?
    var programs:[Program]?
    
    class func channels()->[Channel]
    {
        var channels : [Channel] = []
        let cal = NSCalendar.currentCalendar()
        var startDate = NSDate()
        startDate = cal.startOfDayForDate(startDate)
        
        for i in 1...20
        {
            var ch:Channel = Channel()
            ch.channelNumber = "\(i)"
            ch.channelName = "CH \(i)"
            ch.programs = []
            
            //Lets generate some programs data,
            var date = cal.dateByAddingUnit(.DayCalendarUnit, value: -1, toDate: startDate, options: nil)!
            var endDate = startDate.dateByAddingTimeInterval(60 * 60 * 24 * 7)
            
            var j = 1
            while (date.compare(endDate) == NSComparisonResult.OrderedAscending)
            {
                var program = Program()
                program.name = "Program \(j)"
                var random = Int(arc4random_uniform(2)+1)
                program.startTime = date
                program.endTime = date.dateByAddingTimeInterval(Double(random) * 3600)!
                date = program.endTime!
                ch.programs?.append(program)
                j++
            }
            channels.append(ch)
        }
        return channels
    }
}
extension Channel : Printable, DebugPrintable
{
    
    override var description : String
        {
            return "Channel Name: \(channelName) programs \(programs)\n"
    }
    
    override var debugDescription : String
        {
            return "Channel Name: \(channelName) programs \(programs)\n"
    }
}
