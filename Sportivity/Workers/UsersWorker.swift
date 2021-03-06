//
//  UsersWorker.swift
//  Sportivity
//
//  Created by Paweł Zykowski on 13.05.2016.
//  Copyright © 2016 Paweł Zykowski. All rights reserved.
//

import Foundation


class UsersWorker {
    
    var userService: UserManagementServiceProtocol
    
    init(withService service: UserManagementServiceProtocol) {
        self.userService = service
    }
    
    func authenticateUser(user: String, withPassword password: String, andCallFunction function: Bool -> ()) {
        self.userService.authenticateUser(user, withPassword: password, andCallFunction: function)
    }
    
    func logOutCurrentUser() {
        self.userService.logOutCurrentUser()
    }
    
    func loadImage(of username: String, reportProgressWith function: Float -> (), andWhenDone completion: UIImage -> ()) {
        self.userService.loadImage(of: username, reportProgressWith: function, andWhenDone: completion)
    }
}


protocol UserManagementServiceProtocol {
    
    func authenticateUser(user: String, withPassword password: String, andCallFunction function: Bool -> ())
    func logOutCurrentUser()
    func loadImage(of username: String, reportProgressWith function: Float -> (), andWhenDone completion: UIImage -> ())
}

