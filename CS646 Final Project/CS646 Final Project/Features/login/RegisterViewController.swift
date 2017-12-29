//
//  RegisterViewController.swift
//  CS646 Final Project
//
//  Created by Reed  Hamilton on 12/5/17.
//  Copyright © 2017 Reed  Hamilton. All rights reserved.
//

import UIKit
import SQLite

class RegisterViewController: UIViewController {
    
    
    var database: Connection!
    let userTable = Table("users")
    @IBOutlet weak var userPwd: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var repeatPwd: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var pwdLabel: UILabel!
    @IBOutlet weak var verifyLabel: UILabel!
    
    let emailExp = Expression<String?>("email")
    let passwordExp = Expression<String?>("password")
    let firstExp = Expression<String?>("firstName")
    let lastExp = Expression<String?>("lastName")
    let userID = Expression<Int64?>("id")
    var email: String?
    var password: String?
    var repeatPass: String?
    var first: String?
    var last: String?
    var id: Int64?
    
    @IBAction func regUser(_ sender: UIButton) {
        guard (emailCheck() == true) else {
            emailLabel.text = "Invalid email."
            return
        }
        guard (passwordCheck() == true) else {
            pwdLabel.text = "Invalid password."
            return
        }
        guard userPwd!.text == repeatPwd!.text else {
            verifyLabel.text = "Password does not match."
            return }
        guard (nameCheck() == true) else {
            firstLabel.text = "Required."
            lastLabel.text = "Required."
            return
        }
        
        let insertUser = self.userTable.insert(self.emailExp <- email, self.passwordExp <- password, self.firstExp <- first, self.lastExp <- last)
        do{
            try self.database.run(insertUser)
            print("INSERTED USER")
            let users = try self.database.prepare(userTable)
            for user in users {
                if email == user[self.emailExp]{
                    self.id = user[self.userID]
                }
            }
            emailLabel.text = ""
            pwdLabel.text = ""
            verifyLabel.text = ""
            firstLabel.text = ""
            lastLabel.text = ""
            performSegue(withIdentifier: "two", sender: self)
        }
        catch{print(error)}
    }
    
    func emailCheck() -> Bool {
        guard userEmail != nil else {return false}
        email = userEmail.text
        if (email!.contains("@") && (email!.count > 3)) {
            do {
                let users = try self.database.prepare(self.userTable)
                for user in users{
                    print("Email: \(user[self.emailExp]!)" + " Password: \(user[self.passwordExp]!)")
                    if email! == user[self.emailExp] {
                        print("Email already exists")
                        return false
                    }
                }
                return true
            } catch {print(error)}
        }
        return false
    }
    
    func passwordCheck() -> Bool {
        guard userPwd != nil && repeatPwd != nil else {return false}
        password = userPwd!.text
        if password!.count > 3 {return true}
        else {return false}
    }
    func nameCheck() -> Bool {
        guard lastName.hasText else {return false}
        guard firstName.hasText else {return false}
        first = firstName!.text
        last = lastName!.text
        return true
    }
    
    //Open user databse to register new users
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            var db: OpaquePointer?
            
            if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {print("Error opening the database")}
            else {print("TABLE OPENED")}
        } catch {print(error)}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let myVC = segue.destination as? UITabBarController {
            if let nav = myVC.viewControllers?.first as? UINavigationController{
                if let destinationViewController = nav.viewControllers.first as? FourthViewController {
                destinationViewController.fullName = (self.first! + " " + self.last!)
                destinationViewController.id = self.id!
                destinationViewController.userEmail = self.email!
                }
            }
        }
    }

}
