//
//  SecondViewController.swift
//  CS646 Final Project
//
//  Created by Reed  Hamilton on 11/27/17.
//  Copyright © 2017 Reed  Hamilton. All rights reserved.
//

import UIKit
import SQLite

class SecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    var database: Connection!
    var data: Connection!
    let userTable = Table("users")
    let workTable = Table("Workouts")
    let firstName = Expression<String?>("firstName")
    let lastName = Expression<String?>("lastName")
    let workoutID = Expression<Int64>("workoutID")
    let userID = Expression<Int64>("userID")
    let id = Expression<Int64>("id")
    let workoutName = Expression<String>("workoutName")
    let fullName = Expression<String>("fullName")
    let category = Expression<String>("category")
    let goal = Expression<String>("goal")
    let durationExp = Expression<String>("duration")
    let instructionsExp = Expression<String>("instructions")
    
    struct entry {
        var workoutName:String?
        var user:Int64?
    }

    var workouts: Array<entry>?
    var categories: [String?] = []
    var goals: [String?] = []
    var durations: [String?] = []
    var selectedCat: String?
    var selectedGoal: String?
    var selectedDur: String?
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return categories.count
        case 1:
            return goals.count
        case 2:
            return durations.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return categories[row]
        case 1:
            return goals[row]
        case 2:
            return durations[row]
        default:
            return "None"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedCat = categories[row]
            if selectedCat == "None" {
                tableView.reloadData()
                return
            }
            workouts = []
            do {
                let userWorkouts = try self.database.prepare(workTable)
                if selectedGoal != nil && selectedGoal != "None" {
                    if selectedDur != nil && selectedDur != "None" {
                        for index in userWorkouts {
                            if selectedCat == index[self.category]{
                                if selectedGoal == index[self.goal]{
                                    if selectedDur == index[self.durationExp]{
                                        workouts?.append(entry(workoutName: index[self.workoutName], user: index[self.userID]))
                                    }
                                }
                            }
                        }
                        tableView.reloadData()
                        return
                    }
                    else {
                        for index in userWorkouts {
                            if selectedCat == index[self.category]{
                                if selectedGoal == index[self.goal]{
                                    workouts?.append(entry(workoutName: index[self.workoutName], user: index[self.userID]))
                                }
                            }
                        }
                        tableView.reloadData()
                        return
                    }
                }
                else {
                    if selectedDur != nil && selectedDur != "None" {
                        for index in userWorkouts {
                            if selectedCat == index[self.category]{
                                if selectedDur == index[self.durationExp]{
                                    workouts?.append(entry(workoutName: index[self.workoutName], user: index[self.userID]))
                                }
                            }
                        }
                        tableView.reloadData()
                        return
                    }
                    else {
                        for index in userWorkouts {
                            if selectedCat == index[self.category]{
                                    workouts?.append(entry(workoutName: index[self.workoutName], user: index[self.userID]))
                            }
                        }
                        tableView.reloadData()
                        return
                    }
                }
            } catch {print(error)}
        case 1:
            selectedGoal = goals[row]
            if selectedGoal == "None" {
                tableView.reloadData()
                return
            }
            workouts = []
            do {
                let userWorkouts = try self.database.prepare(workTable)
                if selectedCat != nil && selectedCat != "None" {
                    if selectedDur != nil && selectedDur != "None" {
                        for index in userWorkouts {
                            if selectedCat == index[self.category]{
                                if selectedGoal == index[self.goal]{
                                    if selectedDur == index[self.durationExp]{
                                        workouts?.append(entry(workoutName: index[self.workoutName], user: index[self.userID]))
                                    }
                                }
                            }
                        }
                        tableView.reloadData()
                        return
                        //both yes
                    }
                    else {
                        for index in userWorkouts {
                            if selectedCat == index[self.category]{
                                if selectedGoal == index[self.goal]{
                                        workouts?.append(entry(workoutName: index[self.workoutName], user: index[self.userID]))
                                }
                            }
                        }
                        tableView.reloadData()
                        return
                    }
                }
                else {
                    if selectedDur != nil && selectedDur != "None" {
                        for index in userWorkouts {
                            if selectedGoal == index[self.goal]{
                                if selectedDur == index[self.durationExp]{
                                   workouts?.append(entry(workoutName: index[self.workoutName], user: index[self.userID]))
                                }
                            }
                        }
                        tableView.reloadData()
                        return
                        // dur
                    }
                    else {
                        for index in userWorkouts {
                            if selectedGoal == index[self.goal]{
                                    workouts?.append(entry(workoutName: index[self.workoutName], user: index[self.userID]))
                            }
                        }
                        tableView.reloadData()
                        return
                        //both no
                    }
                }
            } catch{print(error)}
            
        case 2:
            selectedDur = durations[row]
            if selectedDur == "None" {
                tableView.reloadData()
                return
            }
            workouts = []
            do {
                let userWorkouts = try self.database.prepare(workTable)
                if selectedGoal != nil && selectedGoal != "None" {
                    if selectedCat != nil && selectedCat != "None" {
                        for index in userWorkouts {
                            if selectedCat == index[self.category]{
                                if selectedGoal == index[self.goal]{
                                    if selectedDur == index[self.durationExp]{
                                       workouts?.append(entry(workoutName: index[self.workoutName], user: index[self.userID]))
                                    }
                                }
                            }
                        }
                        tableView.reloadData()
                        return
                    }
                    else{
                        for index in userWorkouts {
                            if selectedGoal == index[self.goal]{
                                if selectedDur == index[self.durationExp]{
                                   workouts?.append(entry(workoutName: index[self.workoutName], user: index[self.userID]))
                                }
                            }
                        }
                        tableView.reloadData()
                        return
                    }
                }
                else {
                    if selectedCat != nil && selectedCat != "None" {
                        for index in userWorkouts {
                            if selectedCat == index[self.category]{
                                if selectedDur == index[self.durationExp]{
                                    workouts?.append(entry(workoutName: index[self.workoutName], user: index[self.userID]))
                                }
                            }
                        }
                        tableView.reloadData()
                        return
                    }
                    else{
                        for index in userWorkouts {
                            if selectedDur == index[self.durationExp]{
                               workouts?.append(entry(workoutName: index[self.workoutName], user: index[self.userID]))
                            }
                        }
                        tableView.reloadData()
                        return
                    }
                    
                }
            } catch{print(error)}
            
        default:
            do{
                let userWorkouts = try self.database.prepare(workTable)
                for index in userWorkouts {
                    workouts?.append(entry(workoutName: index[self.workoutName], user: index[self.userID]))
                }
                tableView.reloadData()
            } catch {print(error)}
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "go", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard workouts != nil else {return 1}
        return (workouts?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as UITableViewCell
        guard workouts?.isEmpty != true else {
            cell.textLabel!.text = "None"
            return cell
        }
        cell.textLabel!.text = workouts?[indexPath.row].workoutName
        return cell
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        categories = ["Upper Body", "Chest", "Shoulders", "Back", "Arms","Core", "Lower Body", "Quads", "Hamstrings", "Glutes", "Calves", "Cardio", "Athleticism", "Circuit"]
        goals = ["Build Mass", "Build Strength", "Mass and Strength", "Burn Calories", "Build Endurance", "Gain Definition"]
        durations = ["0-30 minutes", "30-60 minutes", "60-90 minutes", "90-120 minutes", "120+ minutes"]
        pickerView.delegate = self
        pickerView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.dataSource = self
        tableView.delegate = self
        workouts = []
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("Workouts").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            var db: OpaquePointer?
            if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {print("Error opening the database")}
            else {print("TABLE OPENED")}
        } catch {print(error)}
        do{
            let userWorkouts = try self.database.prepare(workTable)
            for index in userWorkouts {
                workouts?.append(entry(workoutName: index[self.workoutName], user: index[self.userID]))
            }
            tableView.reloadData()
        } catch {print(error)}
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var fullName: String = ""
        if let tableVC = segue.destination as? View {
                tableVC.user = self.workouts![(tableView.indexPathForSelectedRow?.row)!].user!
                tableVC.workoutName = self.workouts![(tableView.indexPathForSelectedRow?.row)!].workoutName!
            do {
                let document = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let file = document.appendingPathComponent("users").appendingPathExtension("sqlite3")
                let data = try Connection(file.path)
                self.data = data
                var db: OpaquePointer?
                if sqlite3_open(file.path, &db) != SQLITE_OK {print("Error opening the database")}
                else {print("TABLE OPENED")}
                let users = try self.data.prepare(userTable)
                for index in users {
                    if self.workouts![(tableView.indexPathForSelectedRow?.row)!].user! == index[self.id]{
                        fullName = "By " + index[self.firstName]! + " " + index[self.lastName]!
                    }
                }
                if sqlite3_close(db) != SQLITE_OK {print("Error closing the database")}
                else{print("TABLE CLOSED")}
            } catch {print(error)}
            tableVC.personName = fullName
        }
    }


}

