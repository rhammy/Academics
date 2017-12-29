//
//  AddWorkoutView.swift
//  CS646 Final Project
//
//  Created by Reed  Hamilton on 12/15/17.
//  Copyright © 2017 Reed  Hamilton. All rights reserved.
//

import UIKit
import SQLite

class AddWorkoutView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var database: Connection!
    let workTable = Table("Workouts")
    let workoutID = Expression<Int64>("workoutID")
    let userID = Expression<Int64>("userID")
    let workoutName = Expression<String>("workoutName")
    let fullName = Expression<String>("fullName")
    let category = Expression<String>("category")
    let goal = Expression<String>("goal")
    let durationExp = Expression<String>("duration")
    let instructionsExp = Expression<String>("instructions")
    var categories: [String?] = []
    var goals: [String?] = []
    var durations: [String?] = []
    var selectedCat: String?
    var selectedGoal: String?
    var selectedDur: String?
    var user: Int64?
    var full: String?

    @IBOutlet weak var workout: UITextField!
    @IBOutlet weak var catergoryPicker: UIPickerView!
    @IBOutlet weak var goalPicker: UIPickerView!
    @IBOutlet weak var duration: UIPickerView!
    @IBOutlet weak var instructions: UITextView!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var catLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var durLabel: UILabel!
    @IBOutlet weak var inLabel: UILabel!
    
    
    @IBAction func add(_ sender: Any) {
        guard workout.hasText else {
            workLabel.text = "Required"
            return
        }
        guard instructions.hasText else {
            inLabel.text = "Required"
            return
        }
        guard selectedCat != nil else {
            catLabel.text = "Required"
            return
        }
        guard selectedGoal != nil else {
            goalLabel.text = "Required"
            return
        }
        guard selectedDur != nil else {
            durLabel.text = "Required"
            return
        }
        guard user != nil else{
            print("No user")
            return
        }
        guard full != nil else{
            return
        }

        let insertWork = self.workTable.insert(self.userID <- user!,self.workoutName <- workout.text!, self.fullName <- full!, self.category <- selectedCat!, self.goal <- selectedGoal!, self.durationExp <- selectedDur!, self.instructionsExp <- instructions.text)
        do{
            try self.database.run(insertWork)
            print("INSERTED WORKOUT")
            let alert = UIAlertController(title: "Workout Added", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            workout.text = ""
            instructions.text = ""
            workLabel.text = ""
            inLabel.text = ""
            catLabel.text = ""
            durLabel.text = ""
            goalLabel.text = ""
        }
        catch{print(error)}
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return categories.count
        case 2:
            return goals.count
        case 3:
            return durations.count
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return categories[row]
        case 2:
            return goals[row]
        case 3:
            return durations[row]
        default:
            return "None"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            selectedCat = categories[row]
        case 2:
            selectedGoal = goals[row]
        case 3:
            selectedDur = durations[row]
        default:
            return
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        catergoryPicker.tag = 1
        catergoryPicker.dataSource = self
        catergoryPicker.delegate = self
        goalPicker.tag = 2
        goalPicker.dataSource = self
        goalPicker.delegate = self
        duration.tag = 3
        duration.dataSource = self
        duration.delegate = self
        categories = ["Upper Body", "Chest", "Shoulders", "Back", "Arms","Core", "Lower Body", "Quads", "Hamstrings", "Glutes", "Calves", "Cardio", "Athleticism", "Circuit"]
        goals = ["Build Mass", "Build Strength", "Mass and Strength", "Burn Calories", "Build Endurance", "Gain Definition"]
        durations = ["0-30 minutes", "30-60 minutes", "60-90 minutes", "90-120 minutes", "120+ minutes"]
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("Workouts").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            let createTable = self.workTable.create { (table) in
                table.column(self.workoutID, primaryKey: true)
                table.column(self.userID)
                table.column(self.workoutName)
                table.column(self.fullName)
                table.column(self.category)
                table.column(self.goal)
                table.column(self.durationExp)
                table.column(self.instructionsExp)
            }
            do {
                try self.database.run(createTable)
            } catch {print(error)}
        } catch {print(error)}

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? TableViewController {
            destinationViewController.fullName = self.full
            destinationViewController.user = self.user!
        }
        if let destinationViewController = segue.destination as? Navigation {
            destinationViewController.full = self.full
            destinationViewController.user = self.user!
        }
    }

}
