//
//  Channel.swift
//  EPG
//
//  Created by Adnan Aftab on 2/14/15.
//  Copyright (c) 2015 CX. All rights reserved.
//

import UIKit

class Channel: NSObject {
    var channelNumber:String?
    var channelName:String?
    var programs:[Program]?
}

extension Channel {
    override var description : String {
            return "Channel Name: \(channelName) programs \(programs)\n"
    }
    
    override var debugDescription : String {
            return "Channel Name: \(channelName) programs \(programs)\n"
    }
}

extension Channel {
    class func channels()->[Channel] {
        var channels : [Channel] = []
        let cal = Calendar.current
        var date = Date()
        date = cal.startOfDay(for: date)
        
        guard let startDate = cal.date(byAdding: .day, value: -1, to: date) else { return [] }
        
        let endDate = startDate.addingTimeInterval(60 * 60 * 24 * 7)
        
        for i in 1...100 {
            let ch:Channel = Channel()
            ch.channelNumber = "\(i)"
            ch.channelName = "CH \(i)"
            ch.programs = []
            ch.programs = programs(from: date, to: endDate)
            channels.append(ch)
        }
        
        return channels
    }
    
    private class func programs(from startDate: Date, to endDate: Date) -> [Program] {
        var programStartTime = startDate
        var j = 1
        var programs = [Program]()
        while programStartTime.compare(endDate) == .orderedAscending {
            let program = Program()
            program.name = "Program \(j)"
            let random = Int(arc4random_uniform(2)+1)
            program.startTime = programStartTime
            let programEndTime = programStartTime.addingTimeInterval(Double(random) * 3600)
            program.endTime = programEndTime
            programStartTime = programEndTime
            programs.append(program)
            j += 1
        }
        return programs
    }
}
