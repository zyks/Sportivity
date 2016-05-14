//
//  UserManagementKinvey.swift
//  Sportivity
//
//  Created by Paweł Zykowski on 13.05.2016.
//  Copyright © 2016 Paweł Zykowski. All rights reserved.
//

import Foundation


class UserManagementKinvey : UserManagementServiceProtocol {
    
    required init(needsInitialization: Bool, withParams params: [String: String]) {
        if needsInitialization {
            if let appID = params["appID"], appSecret = params["appSecret"] {
                self.initializeKinveyClient(appID, appSecret: appSecret)
            } else { NSLog("Wrong parameters. Could not initialize Kinvey client.") }
        }
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
    
}

