//
//  AdminDashboard.swift
//  InternshipManagementSystem
//
//  Created by Student on 5/30/22.
//

import UIKit

class AdminDashboard: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func onLogOut(_ sender: Any) {
        
        UserDefaultsManager.shared.clearUserDefaults()
        
        SceneDelegate.shared?.checkLogin()
        
    }
    

}
