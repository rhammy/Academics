//
//  ProfileNav.swift
//  CS646 Final Project
//
//  Created by Reed  Hamilton on 12/21/17.
//  Copyright © 2017 Reed  Hamilton. All rights reserved.
//

import UIKit

class ProfileNav: UINavigationController {
    var fullName = String()
    var userEmail = String()
    var id = Int64()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? FourthViewController{
            destinationViewController.fullName = self.fullName
            destinationViewController.id = self.id
            destinationViewController.userEmail = self.userEmail
        }
    }*/
}
