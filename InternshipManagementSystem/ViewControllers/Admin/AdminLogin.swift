//
//  AdminLogin.swift
//  InternshipManagementSystem
//
//  Created by Student on 5/26/22.
//

import UIKit

class AdminLogin: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
   
    override func viewDidLoad() {
        
//        SceneDelegate.shared?.checkLogin()
       
    }
    
    @IBAction func onLogin(_ sender: Any) {
        
        if(!CommonMethods.shared.isValidEmail(testStr: email.text!)) {
             showAlertAnyWhere(message: "Please enter valid email.")
            return
        }
        
        
        if(self.password.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter password.")
            return
        }
        
        FireStoreManager.shared.login(email: email.text!.lowercased(), password: password.text!, userType: "admin")
    }
    
    
    @IBAction func onRegister(_ sender: Any) {
        
    }
    
    @IBAction func onForgotPassword(_ sender: Any) {
        
    }
   
    

}
