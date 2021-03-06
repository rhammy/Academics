//
//  TableViewController.swift
//  CS646 Final Project
//
//  Created by Reed  Hamilton on 12/15/17.
//  Copyright © 2017 Reed  Hamilton. All rights reserved.
//

import UIKit
import SQLite

class TableViewController: UITableViewController {
    
    var database: Connection!
    let workTable = Table("Workouts")
    let workoutName = Expression<String>("workoutName")
    let userID = Expression<Int64>("userID")
    var user: Int64?
    var fullName: String?
    var email: String?
    var workouts: [String?] = []


    @IBAction func back(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: self)
    }
    @IBOutlet weak var myWorkouts: UITableView!
    @IBAction func addWorkout(_ sender: Any) {
        performSegue(withIdentifier: "Add", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Default cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        guard workouts.isEmpty != true else {
            cell.textLabel!.text = "None"
            return cell
        }
        cell.textLabel!.text = workouts[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "workout", sender: self)
    }
    
   
    
    @objc func refresh(sender:AnyObject) {
       
        myWorkouts.dataSource = self
        myWorkouts.delegate = self
        workouts = []
        do {
            let userWorkouts = try self.database.prepare(workTable)
            for works in userWorkouts {
                if user! == works[self.userID]{
                    workouts.append(works[self.workoutName])
                    print("\(works[self.workoutName])")
                }
            }
            myWorkouts.reloadData()
            refreshControl?.endRefreshing()
        } catch {print(error)}
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myWorkouts.reloadData()
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshControl?.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControlEvents.valueChanged)
        guard user != nil else {return}
        myWorkouts.dataSource = self
        myWorkouts.delegate = self
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("Workouts").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            var db: OpaquePointer?
            if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {print("Error opening the database")}
            else {print("TABLE OPENED")}
        } catch {print(error)}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myWorkouts.reloadData()
        guard user != nil else {return}
        myWorkouts.dataSource = self
        myWorkouts.delegate = self
        workouts = []
        do {
            let userWorkouts = try self.database.prepare(workTable)
            for works in userWorkouts {
                if user! == works[self.userID]{
                    workouts.append(works[self.workoutName])
                    print("\(works[self.workoutName])")
                }
            }
        } catch {print(error)}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? AddWorkoutView {
            destinationViewController.full = self.fullName
            destinationViewController.user = self.user!
        }
        if let destinationViewController = segue.destination as? DisplayInfo {
            destinationViewController.user = self.user!
            destinationViewController.workoutName = self.workouts[(myWorkouts.indexPathForSelectedRow?.row)!]!
        }
        if let myVC = segue.destination as? UITabBarController {
            if let nav = myVC.viewControllers?.first as? UINavigationController{
                if let destinationViewController = nav.viewControllers.first as? FourthViewController {
                destinationViewController.fullName = self.fullName!
                destinationViewController.id = self.user!
                destinationViewController.userEmail = self.email!
                }
            }
        }
    }
    
}

