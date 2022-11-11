 

import UIKit

class StudentFourmTwo: UIViewController {

    @IBOutlet weak var contact: UITextField!
    @IBOutlet weak var pocEmail: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var company: UITextField!
    var firstPageData = [String:String]()
    
    override func viewDidLoad() {
       // self.setDummy()
    }
    
    func setDummy() {
        
        self.contact.text! = "666666"
        self.pocEmail.text! = "js@gmail.com"
        self.location.text! = "HYD"
        self.company.text! = "JS"
    }
     
    @IBAction func onNext(_ sender: Any) {
        
        if(validate()) {
            
            self.firstPageData.updateValue(self.contact.text!, forKey: "pocContact")
            self.firstPageData.updateValue(self.pocEmail.text!, forKey: "pocEmail")
            self.firstPageData.updateValue(self.location.text!, forKey: "location")
            self.firstPageData.updateValue(self.company.text!.lowercased(), forKey: "company")
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "StudentFourmFinal") as! StudentFourmFinal
            vc.secondPageData = firstPageData
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    
    func validate() ->Bool {
        
        if(self.contact.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter contact.")
            return false
        }
        
        
        if(!CommonMethods.shared.isValidPhone(phone: self.contact.text!)) {
             showAlertAnyWhere(message: "Please enter valid contact number.")
            return false
        }
        
        if(!CommonMethods.shared.isValidEmail(testStr: pocEmail.text!)) {
             showAlertAnyWhere(message: "Please enter valid email.")
            return false
        }
        
        if(self.location.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter location.")
            return false
        }
        
        if(self.company.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter company.")
            return false
        }
        
        return true
    }
    
    

}
