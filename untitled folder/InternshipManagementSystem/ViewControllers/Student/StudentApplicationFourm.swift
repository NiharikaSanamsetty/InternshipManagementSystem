 
import UIKit

class StudentFourmFirst: UIViewController{
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var department: UITextField!
    @IBOutlet weak var contact: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    override func viewDidLoad() {
        self.setDummy()
    }
    
    func setDummy() {
        
        self.firstName.text! = "NIRAJ"
        self.department.text! = "IT"
        self.contact.text! = "7777777"
        self.lastName.text! = "KUrmi"
        self.email.text! = UserDefaultsManager.shared.getEmail()
    }
    @IBAction func onNext(_ sender: Any) {
        
        let dictonary =  ["firstName" : firstName.text! , "lastName" : lastName.text!, "contact" : contact.text!, "email" : email.text!,"department" : department.text!]
        
        if(validate()) {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "StudentFourmTwo") as! StudentFourmTwo
            vc.firstPageData = dictonary
            self.navigationController!.pushViewController(vc, animated: true)
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
        
        return true
    }
    
    
}
