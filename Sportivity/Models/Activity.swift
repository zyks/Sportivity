//
//  Activity.swift
//  Sportivity
//
//  Created by Paweł Zykowski on 14.05.2016.
//  Copyright © 2016 Paweł Zykowski. All rights reserved.
//

class Activity {
    
    var type: String
    var startsAt: NSDate
    var endsAt: NSDate
    
    init(type: String, startsAt: NSDate, endsAt: NSDate){
        self.type = type
        self.startsAt = startsAt
        self.endsAt = endsAt
    }
    
}
