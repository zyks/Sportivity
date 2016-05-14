//
//  ActivitiesWorker.swift
//  Sportivity
//
//  Created by Paweł Zykowski on 14.05.2016.
//  Copyright © 2016 Paweł Zykowski. All rights reserved.
//

import Foundation


class ActivitiesWorker {
    
    var activityService: ActivityManagementServiceProtocol
    
    init(withService service: ActivityManagementServiceProtocol) {
        self.activityService = service
    }
    
    func loadActivities(of username: String, andCallFunction function: [Activity] -> ()) {
        return self.activityService.loadActivities(of: username, andCallFunction: function)
    }
    
}


protocol ActivityManagementServiceProtocol {
    
    init(needsInitialization: Bool, withParams params: [String: AnyObject])
    func loadActivities(of username: String, andCallFunction function: [Activity] -> ())
    
}