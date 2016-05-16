//
//  UserViewController.swift
//  Sportivity
//
//  Created by Paweł Zykowski on 13.05.2016.
//  Copyright © 2016 Paweł Zykowski. All rights reserved.
//

import UIKit


class UserViewController: UIViewController, DonutChartDataSource {
    
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var donutChart: DonutChart!
    
    var progress: [String: Float] = [String: Float]() {
        didSet {
            let percent = self.progress.values.reduce(0.0, combine: +) / Float(self.progress.count)
            progressBar.setProgress(percent, animated: true)
            if percent == 1.0 {
                self.fadeOutProgressBar()
                self.fadeInComponents()
            }
        }
    }
    var usersWorker: UsersWorker?
    var activitiesWorker: ActivitiesWorker?
    var currentUser: User?
    var userActivities: [Activity] = []
    var activitiesSummary: [String: Double] = [String: Double]() {
        didSet {
            self.donutChart.setNeedsDisplay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.helloLabel.alpha = 0.0
        self.logOutButton.alpha = 0.0
        self.donutChart.alpha = 0.0
        self.helloLabel.text = "Hello, \(currentUser!.name)!"
        self.donutChart.dataSource = self
        
        self.activitiesWorker = ActivitiesWorker(withService: ActivityManagementKinvey())
        self.progress["loadingActivities"] = 0.0
        self.activitiesWorker!.loadActivities(
            of: currentUser!.name,
            reportProgressWith: { self.progress["loadingActivities"] = $0 },
            andWhenDone: self.storeLoadedActivities
        )

    }
    
    func storeLoadedActivities(activities: [Activity]) {
        self.userActivities = activities
        self.summarizeUserActivities()
    }
    
    // from date to date?
    func summarizeUserActivities() {
        for activity in self.userActivities {
            let intervalInMinutes = Double(activity.endsAt.timeIntervalSinceDate(activity.startsAt) / 60)
            
            if self.activitiesSummary[activity.type] != nil {
                self.activitiesSummary[activity.type]! += intervalInMinutes
            } else {
                self.activitiesSummary[activity.type] = intervalInMinutes
            }
        }
    }
    
    func dataForDonutChart() -> [String : Double] {
        return self.activitiesSummary
    }
    
    func imageForDonutChart() -> UIImage? {
        return nil
    }
    
    func fadeOutProgressBar() {
        UIView.animateWithDuration(
            0.5,
            delay: 0.5,
            options: [],
            animations: { self.progressBar.alpha = 0 },
            completion: nil
        )
    }
    
    func fadeInComponents() {
        UIView.animateWithDuration(
            0.75,
            delay: 0.5,
            options: [],
            animations: {
                self.helloLabel.alpha = 1.0
                self.logOutButton.alpha = 1.0
                self.donutChart.alpha = 1.0
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
