//
//  UserViewController.swift
//  Sportivity
//
//  Created by Paweł Zykowski on 13.05.2016.
//  Copyright © 2016 Paweł Zykowski. All rights reserved.
//

import UIKit


class UserViewController: UIViewController {
    
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    var usersWorker: UsersWorker?
    var activitiesWorker: ActivitiesWorker?
    var currentUser: User?
    var userActivities: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.helloLabel.text = "Hello, \(currentUser!.name)!"
        
        self.activitiesWorker = ActivitiesWorker(
            withService: ActivityManagementKinvey(
                needsInitialization: true,
                withParams: ["collection": "Activities", "entityTemplate": ActivityEntity.self]
            )
        )
        self.activitiesWorker!.loadActivities(of: currentUser!.name, andCallFunction: storeLoadedActivities)
    }
    
    func storeLoadedActivities(activities: [Activity]) {
        self.userActivities = activities
        //for activity in self.userActivities {
        //    NSLog("\(activity.type), \(activity.startsAt), \(activity.endsAt)")
        //}
    }
    
    @IBAction func logOutTouchUpInside(sender: AnyObject) {
        NSLog("Log out")
        self.usersWorker!.logOutCurrentUser()
        performSegueWithIdentifier("fromUserToLogin", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
