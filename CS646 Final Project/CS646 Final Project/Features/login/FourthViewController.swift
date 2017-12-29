//
//  FourthViewController.swift
//  CS646 Final Project
//
//  Created by Reed  Hamilton on 11/28/17.
//  Copyright © 2017 Reed  Hamilton. All rights reserved.
//

import UIKit

class FourthViewController: UIViewController {
    
    var fullName = String()
    var userEmail = String()
    var id = Int64()
    @IBOutlet weak var full: UILabel!
    @IBOutlet weak var email: UILabel!

    @IBAction func signOut(_ sender: Any) {
        performSegue(withIdentifier: "signOut", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        full.text = fullName
        email.text = userEmail
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVC = segue.destination as? UINavigationController {
            if let tableVC = navVC.viewControllers.first as? TableViewController {
            tableVC.fullName = self.fullName
            tableVC.user = self.id
            tableVC.email = self.userEmail
            }
        }
    }
}
