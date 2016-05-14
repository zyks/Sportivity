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
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.helloLabel.text = "Hello, \(currentUser!.name)!"
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
