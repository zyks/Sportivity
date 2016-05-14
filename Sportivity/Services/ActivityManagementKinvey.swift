//
//  ActivityManagementKinvey.swift
//  Sportivity
//
//  Created by Paweł Zykowski on 14.05.2016.
//  Copyright © 2016 Paweł Zykowski. All rights reserved.
//

import Foundation


class ActivityManagementKinvey : ActivityManagementServiceProtocol {
    
    var store: KCSAppdataStore?
    
    required init(needsInitialization: Bool, withParams params: [String: AnyObject]) {
        if needsInitialization {
            if let collection = params["collection"], template = params["entityTemplate"] where collection is String {
                self.store = KCSAppdataStore.storeWithOptions([
                    KCSStoreKeyCollectionName : collection,
                    KCSStoreKeyCollectionTemplateClass : template
                    ])
            } else { NSLog("Wrong parameters. Could not initialize Kinvey store.") }
        }
    }
    
    func loadActivities(of username: String, andCallFunction function: [Activity] -> ()) {
        store!.queryWithQuery(
            KCSQuery(onField: "username", withExactMatchForValue: username),
            withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                if errorOrNil == nil {
                    NSLog("Successfully loaded user activities")
                    var result: [Activity] = [Activity]()
                    for object in objectsOrNil {
                        result.append((object as! ActivityEntity).toActivity())
                    }
                    function(result)
                } else {
                    NSLog("Could not load user activities, error occurred: %@", errorOrNil)
                }
            },
            withProgressBlock: { (objects: [AnyObject]!, percentComplete: Double) -> Void in
                //NSLog(String(percentComplete))
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


