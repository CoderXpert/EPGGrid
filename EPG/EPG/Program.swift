//
//  Program.swift
//  EPG
//
//  Created by Adnan Aftab on 2/14/15.
//  Copyright (c) 2015 CX. All rights reserved.
//

import UIKit

class Program: NSObject {
    var name : String?
    var startTime : Date?
    var endTime : Date?
    var timeString : String {
        guard let startTime = startTime, let endTime = endTime else { return "No info available" }
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "h:mma"
        return "\(dateFormater.string(from: startTime)) - \(dateFormater.string(from: endTime))"
    }
    var duration : TimeInterval {
        guard let startTime = startTime, let endTime = endTime else { return 0 }
        return endTime.timeIntervalSince(startTime)
    }
}

extension Program {
    override var description : String {
        return "Program name: \(name) startTIme: \(startTime) endTime \(endTime)\n"
    }
    
    override var debugDescription : String {
        return "Program name: \(name) startTIme: \(startTime) endTime \(endTime)\n"
    }
}
