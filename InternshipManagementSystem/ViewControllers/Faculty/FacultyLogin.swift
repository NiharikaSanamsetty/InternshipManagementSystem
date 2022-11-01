 

import UIKit

class FacultyLogin: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
   
 
    
    @IBAction func onLogin(_ sender: Any) {
        
        if(!CommonMethods.shared.isValidEmail(testStr: email.text!)) {
             showAlertAnyWhere(message: "Please enter valid email address.")
            return
        }
        

        
        if(self.password.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter password.")
            return
        }
        
        FireStoreManager.shared.login(email: email.text!.lowercased(), password: password.text!, userType: "Faculty")
    }
    
     
    
    @IBAction func onForgotPassword(_ sender: Any) {
        
    }
   
    

}
