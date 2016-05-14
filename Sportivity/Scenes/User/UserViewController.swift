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
    @IBOutlet weak var progressBar: UIProgressView!
    
    var progress: Float = 0.0 {
        didSet {
            progressBar.setProgress(self.progress, animated: true)
            if self.progress == 1.0 {
                self.fadeOutProgressBar()
                self.fadeInComponents()
            }
        }
    }
    var usersWorker: UsersWorker?
    var activitiesWorker: ActivitiesWorker?
    var currentUser: User?
    var userActivities: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.helloLabel.alpha = 0.0
        self.logOutButton.alpha = 0.0
        self.helloLabel.text = "Hello, \(currentUser!.name)!"
        
        self.activitiesWorker = ActivitiesWorker(
            withService: ActivityManagementKinvey(
                needsInitialization: true,
                withParams: ["collection": "Activities", "entityTemplate": ActivityEntity.self]
            )
        )
        
        self.activitiesWorker!.loadActivities(
            of: currentUser!.name,
            reportProgressWith: { self.progress = $0 },
            andWhenDone: storeLoadedActivities
        )
    }
    
    func storeLoadedActivities(activities: [Activity]) {
        self.userActivities = activities
        //for activity in self.userActivities {
        //    NSLog("\(activity.type), \(activity.startsAt), \(activity.endsAt)")
        //}
    }
    
    func fadeOutProgressBar() {
        UIView.animateWithDuration(
            0.5,
            delay: 1.0,
            options: [],
            animations: { self.progressBar.alpha = 0 },
            completion: nil
        )
    }
    
    func fadeInComponents() {
        UIView.animateWithDuration(
            0.75,
            delay: 1.0,
            options: [],
            animations: {
                self.helloLabel.alpha = 1.0
                self.logOutButton.alpha = 1.0
            },
            completion: nil
        )
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
