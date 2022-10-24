//
//  AdminRegister.swift
//  InternshipManagementSystem
//
//  Created by Student on 5/26/22.
//

import UIKit

class AdminRegister: UIViewController {

    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var rePassword: UITextField!
    @IBOutlet weak var department: UITextField!
    
    @IBOutlet weak var contact: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         
    }
    
    
    @IBAction func RegisterClick(_ sender: UIButton) {
        
        
        if(self.validate()) {
            
            FireStoreManager.shared.signUp(firstName: firstName.text!, lastName: lastName.text!, email: email.text!.lowercased(), contact: contact.text!, department: department.text!, password: password.text!, userType: "admin")
        }
        
       
    }
    
    func validate() ->Bool {
        
        if(self.firstName.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter first name.")
            return false
        }
        
        if(self.lastName.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter last name.")
            return false
        }
        
        if(!CommonMethods.shared.isValidEmail(testStr: email.text!)) {
             showAlertAnyWhere(message: "Please enter valid email.")
            return false
        }
        
        if(self.contact.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter contact number.")
            return false
        }
        
        if(self.department.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter department.")
            return false
        }
        
        if(self.password.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter password.")
            return false
        }
        
        if(self.password.text! != rePassword.text!) {
             showAlertAnyWhere(message: "Password doesn't match")
            return false
        }
        
        if(self.password.text!.count < 5 || self.password.text!.count > 10 ) {
            
             showAlertAnyWhere(message: "Password  length shoud be 5 to 10")
            return false
        }
        
        
        return true
    }
    
  

}
