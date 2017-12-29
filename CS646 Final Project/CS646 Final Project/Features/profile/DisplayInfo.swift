//
//  DisplayInfo.swift
//  CS646 Final Project
//
//  Created by Reed  Hamilton on 12/15/17.
//  Copyright © 2017 Reed  Hamilton. All rights reserved.
//

import UIKit
import SQLite

class DisplayInfo: UIViewController {
    
    var database: Connection!
    var user = Int64()
    var workoutName = String()
    var personName = String()
    let workTable = Table("Workouts")
    let workout = Expression<String>("workoutName")
    let userID = Expression<Int64>("userID")
    let fullName = Expression<String>("fullName")
    let category = Expression<String>("category")
    let goal = Expression<String>("goal")
    let durationExp = Expression<String>("duration")
    let instructionsExp = Expression<String>("instructions")
    
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var catLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var durLabel: UILabel!
    @IBOutlet weak var instructionLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutLabel.text = workoutName
        personLabel.text = personName
        
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
                if user == works[self.userID]{
                    if workoutName == works[self.workout]{
                        catLabel.text = works[self.category]
                        goalLabel.text = works[self.goal]
                        durLabel.text = works[self.durationExp]
                        instructionLabel.text = works[self.instructionsExp]
                    }
                }
            }
        } catch {print(error)}
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
