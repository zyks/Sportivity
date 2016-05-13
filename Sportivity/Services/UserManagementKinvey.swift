//
//  UserManagementKinvey.swift
//  Sportivity
//
//  Created by Paweł Zykowski on 13.05.2016.
//  Copyright © 2016 Paweł Zykowski. All rights reserved.
//

import Foundation


class UserManagementKinvey : UserManagementServiceProtocol {
    
    func authenticateUser(user: String, withPassword password: String, andCallFunction function: Bool -> ()) {
        KCSUser.loginWithUsername(
            user,
            password: password,
            withCompletionBlock: { (user: KCSUser!, errorOrNil: NSError!, result: KCSUserActionResult) -> Void in
                function(errorOrNil == nil)
            }
        )
    }
    
}

