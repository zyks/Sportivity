//
//  ActivityManagementKinvey.swift
//  Sportivity
//
//  Created by Paweł Zykowski on 14.05.2016.
//  Copyright © 2016 Paweł Zykowski. All rights reserved.
//

import Foundation


class ActivityManagementKinvey : ActivityManagementServiceProtocol {
    
    let store: KCSAppdataStore

    init() {
        self.store = KCSAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activities",
            KCSStoreKeyCollectionTemplateClass : ActivityEntity.self
        ])
    }
    
    func loadActivities(of username: String, reportProgressWith function: Float -> (), andWhenDone completion: [Activity] -> ()) {
        store.queryWithQuery(
            KCSQuery(onField: "username", withExactMatchForValue: username),
            withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                if errorOrNil == nil {
                    NSLog("Successfully loaded user activities")
                    var result: [Activity] = [Activity]()
                    for object in objectsOrNil {
                        result.append((object as! ActivityEntity).toActivity())
                    }
                    completion(result)
                } else { NSLog("Could not load user activities, error occurred: %@", errorOrNil) }
            },
            withProgressBlock: { (objects: [AnyObject]!, percentComplete: Double) -> Void in
                function(Float(percentComplete))
            }
        )
    }
    
}


class ActivityEntity : NSObject {
    
    var type: String?
    var startsAt: NSDate?
    var endsAt: NSDate?
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "type" : "type",
            "startsAt" : "startsAt",
            "endsAt" : "endsAt"
        ]
    }
    
    func toActivity() -> Activity {
        return Activity(type: self.type!, startsAt: self.startsAt!, endsAt: self.endsAt!)
    }
    
}

