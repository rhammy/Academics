//
//  WorkoutsViewController.swift
//  CS646 Final Project
//
//  Created by Reed  Hamilton on 12/14/17.
//  Copyright © 2017 Reed  Hamilton. All rights reserved.
//

import UIKit
import SQLite

class WorkoutsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var database: Connection!
    let workTable = Table("Workouts")
    let workoutName = Expression<String>("workoutName")
    let userID = Expression<Int64>("userID")
    var user: Int64?
    var fullName: String?
    var workouts: [String?] = []
    
    @IBOutlet weak var myWorkouts: UITableView!
    @IBAction func addWorkout(_ sender: Any) {
        performSegue(withIdentifier: "Add", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Default cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        guard workouts.isEmpty != true else {
            cell.textLabel!.text = "None"
            return cell
        }
        cell.textLabel!.text = workouts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "workout", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myWorkouts.reloadData()
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
            
            let userWorkouts = try self.database.prepare(workTable)
                for works in userWorkouts {
                    if user! == works[self.userID]{
                        workouts.append(works[self.workoutName])
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
    }

}
