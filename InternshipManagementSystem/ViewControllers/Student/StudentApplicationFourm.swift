 
import UIKit

class StudentFourmFirst: UIViewController{
    
    @IBOutlet weak var departmentButton: UIButton!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var contact: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var professorEmail: UITextField!
    
    @IBOutlet weak var professorName: UITextField!
    
    
    override func viewDidLoad() {
       
        self.email.isEnabled  = true
        
        self.setMyDetals()
    }
    
    func setMyDetals() {
        
        self.email.text = UserDefaultsManager.shared.getEmail()
        self.firstName.text = UserDefaultsManager.shared.getFirstName()
        self.lastName.text = UserDefaultsManager.shared.getLastName()
        self.contact.text = UserDefaultsManager.shared.getContact()
        
    }
    
    
    
    @IBAction func onDepartment(_ sender: Any) {
        showDepartmentDialog { item in
            self.departmentButton.setTitle(item, for: .normal)
        }
    }
    
    
    @IBAction func onNext(_ sender: Any) {
        
        if(validate()) {
            
            let dictonary =  ["firstName" : firstName.text! , "lastName" : lastName.text!, "contact" : contact.text!, "email" : email.text!,"department" : departmentButton.title(for: .normal)! , "professorName" : professorName.text!,"professorEmail" : professorEmail.text! ]
          
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
        
        if(!CommonMethods.shared.isValidPhone(phone: self.contact.text!)) {
             showAlertAnyWhere(message: "Please enter valid contact number.")
            return false
        }
        
        
        
        if(self.departmentButton.title(for: .normal)! == "Select Department") {
             showAlertAnyWhere(message: "Please enter department.")
            return false
        }
        
        
        if(!CommonMethods.shared.isValidEmail(testStr: professorEmail.text!)) {
             showAlertAnyWhere(message: "Please enter valid email.")
            return false
        }
        
        if(self.professorName.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter professor name.")
            return false
        }
        
       
        
        return true
    }
    
    
}

 
 


