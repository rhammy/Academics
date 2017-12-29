//
//  tabBar.swift
//  CS646 Final Project
//
//  Created by Reed  Hamilton on 12/20/17.
//  Copyright © 2017 Reed  Hamilton. All rights reserved.
//

import UIKit

class tabBar: UITabBarController {
    
    var fullName: String?
    var userID: Int64?
    var userEmail: String?
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController {
            if let destinationViewController = nav.viewControllers.first as? FourthViewController {
                destinationViewController.fullName = self.fullName!
                destinationViewController.id = self.userID!
                destinationViewController.userEmail = self.userEmail!
            }
        }
    }*/
}
