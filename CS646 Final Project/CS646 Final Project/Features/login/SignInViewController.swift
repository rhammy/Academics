//
//  SignInViewController.swift
//  CS646 Final Project
//
//  Created by Reed  Hamilton on 12/5/17.
//  Copyright © 2017 Reed  Hamilton. All rights reserved.
//

import UIKit
import SQLite

class SignInViewController: UIViewController {

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    var database: Connection!
    var data: Connection!
    let userTable = Table("users")
    let id = Expression<Int64>("id")
    let email = Expression<String?>("email")
    let password = Expression<String?>("password")
    let firstName = Expression<String?>("firstName")
    let lastName = Expression<String?>("lastName")
    var userFirst: String?
    var userLast: String?
    var userID: Int64?
    var userEmail: String?
    
    
    //Checks the database for the user
    //Checks if the password is correct
    //Sets the first name last name and userID to variables to be used in profile view
    @IBAction func loginUser(_ sender: UIButton) {
        guard emailInput.hasText else {
            loginLabel.text = "Enter email."
            return
        }
        guard passwordInput.hasText else {
            loginLabel.text = "Enter password."
            return
        }
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            
            let createTable = self.userTable.create { (table) in
                table.column(self.id, primaryKey: true)
                table.column(self.email, unique: true)
                table.column(self.password)
                table.column(self.firstName)
                table.column(self.lastName)
            }
            var db: OpaquePointer?
            if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
                print("Error opening the database")
                try self.database.run(createTable)
                loginLabel.text = "Invalid email or password."
                return
            }
            else {
                let users = try self.database.prepare(userTable)
                for user in users{
                    if emailInput.text == user[self.email] {
                        if passwordInput.text == user[self.password]{
                            self.userID = user[self.id]
                            self.userFirst = user[self.firstName]
                            self.userLast = user[self.lastName]
                            self.userEmail = user[self.email]
                            loginLabel.text = ""
                            emailInput.text = ""
                            passwordInput.text = ""
                            if sqlite3_close(db) != SQLITE_OK {print("Can't close database.")}
                            else {print("TABLE CLOSED")}
                            performSegue(withIdentifier: "one", sender: self)
                        }
                        else {
                            loginLabel.text = "Incorrect password."
                            return
                        }
                    }
                }
                loginLabel.text = "Invalid email."
                return
            }
        }catch {print(error)}
    }
    
    //Create table if not created
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let myVC = segue.destination as? UITabBarController {
            if let nav = myVC.viewControllers?.first as? UINavigationController{
                if let destinationViewController = nav.viewControllers.first as? FourthViewController {
                destinationViewController.fullName = self.userFirst! + " " + self.userLast!
                destinationViewController.id = self.userID!
                destinationViewController.userEmail = self.userEmail!
                }
            }
        }
    }

}
