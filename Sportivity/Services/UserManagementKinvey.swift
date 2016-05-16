//
//  UserManagementKinvey.swift
//  Sportivity
//
//  Created by Paweł Zykowski on 13.05.2016.
//  Copyright © 2016 Paweł Zykowski. All rights reserved.
//

import Foundation


class UserManagementKinvey : UserManagementServiceProtocol {
    
    init(appID: String, appSecret: String) {
        self.initializeKinveyClient(appID, appSecret: appSecret)
    }
    
    func initializeKinveyClient(appID: String, appSecret: String) {
        KCSClient.sharedClient().initializeKinveyServiceForAppKey(
            appID,
            withAppSecret: appSecret,
            usingOptions: nil
        )
    }
    
    func authenticateUser(user: String, withPassword password: String, andCallFunction function: Bool -> ()) {
        KCSUser.loginWithUsername(
            user,
            password: password,
            withCompletionBlock: { (user: KCSUser!, errorOrNil: NSError!, result: KCSUserActionResult) -> Void in
                function(errorOrNil == nil)
            }
        )
    }
    
    func logOutCurrentUser() {
        KCSUser.activeUser().logout()
    }
    
    func loadImage(of username: String, reportProgressWith function: Float -> (), andWhenDone completion: UIImage -> ()) {
        KCSFileStore.downloadFileByQuery(
            KCSQuery(onField: "user", withExactMatchForValue: username),
            completionBlock: { (downloadedResources: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    NSLog("Successfully loaded user image")
                    let file = downloadedResources[0] as! KCSFile
                    let image = UIImage(contentsOfFile: file.localURL.path!)
                    completion(image!)
                } else {
                    NSLog("Got an error: %@", error)
                }
            },
            progressBlock: { (objects: [AnyObject]!, percentComplete: Double) -> Void in
                function(Float(percentComplete))
            }
        )
    }
    
}

