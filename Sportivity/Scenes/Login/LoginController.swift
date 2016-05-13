//
//  LoginController.swift
//  Sportivity
//
//  Created by Paweł Zykowski on 13.05.2016.
//  Copyright © 2016 Paweł Zykowski. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var logInButton: UIButton!
    var waitingForServerResponse: Bool = false {
        didSet {
            self.adjustComponentsToCurrentStatus()
        }
    }
    let usersWorker: UsersWorker = UsersWorker(withService: UserManagementKinvey())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    @IBAction func logInTouchUpInside(sender: AnyObject) {
        NSLog("Trying to log in user: \(usernameTextField.text!), password: \(passwordTextField.text!)")
        self.waitingForServerResponse = true
        self.usersWorker.authenticateUser(usernameTextField.text!, withPassword: passwordTextField.text!, andCallFunction: afterServerResponse)
    }
    
    func afterServerResponse(status: Bool) {
        self.waitingForServerResponse = false
        
        if status == true {
            NSLog("Log in succeeded")
        } else {
            NSLog("Log in failed")
            self.usernameTextField.text = ""
            self.passwordTextField.text = ""
        }
    }
    
    func adjustComponentsToCurrentStatus() {
        self.usernameTextField.enabled = !self.waitingForServerResponse
        self.passwordTextField.enabled = !self.waitingForServerResponse
        self.logInButton.hidden = self.waitingForServerResponse
        if self.waitingForServerResponse {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func backgroundTouched(sender: AnyObject) {
        self.hideKeyboard()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.hideKeyboard()
        return false
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

