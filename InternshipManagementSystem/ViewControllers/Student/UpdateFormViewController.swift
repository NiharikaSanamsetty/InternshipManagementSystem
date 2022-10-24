
import UIKit

class UpdateFormViewController: UIViewController{
   
   @IBOutlet weak var firstName: UITextField!
   @IBOutlet weak var department: UITextField!
   @IBOutlet weak var contact: UITextField!
   @IBOutlet weak var email: UITextField!
   @IBOutlet weak var lastName: UITextField!
   @IBOutlet weak var pocContact: UITextField!
   @IBOutlet weak var pocEmail: UITextField!
   @IBOutlet weak var location: UITextField!
   @IBOutlet weak var company: UITextField!
   
    var querySnapshot : StudentFormData!
    

    override func viewDidLoad() {
        self.title = "Update Form"
        self.setData()
        self.disableEditFields()
    }
    
    
    func disableEditFields() {
        self.email.isUserInteractionEnabled = false
        self.pocEmail.isUserInteractionEnabled = false
    }
    
    
    func setData(){
    
        self.company.text = querySnapshot.company
        self.contact.text = querySnapshot.contact
        self.department.text = querySnapshot.department
        self.email.text = querySnapshot.email
        self.firstName.text = querySnapshot.firstName
        self.lastName.text = querySnapshot.lastName
        self.location.text = querySnapshot.location
        self.pocContact.text = querySnapshot.pocContact
        self.pocEmail.text = querySnapshot.pocEmail
       
    }
   
   @IBAction func onUpdate(_ sender: Any) {
       
       
       if(validate()) {
           
           let newData = StudentFormData(company:  self.company.text!, contact:   self.contact.text!, date: querySnapshot.date!, department:  self.department.text!, email:  self.email.text!, firstName:  self.firstName.text!, lastName:  self.lastName.text!, location:  self.location.text!, pocContact:  self.pocContact.text!, pocEmail:  self.pocEmail.text!, status:  self.querySnapshot.status, uploadFileList:  self.querySnapshot.uploadFileList, id:  self.querySnapshot.id)
        
           FireStoreManager.shared.updateData(documentId:newData.id, data:newData)
           
         
       }
       
      
       
   }
   
    @IBAction func onDelete(_ sender: Any) {
        
        
        FireStoreManager.shared.deleteDocument(documentId:querySnapshot.id) { _ in   
             
            studentApplicationStatusVC.querySnapshot.removeAll()
            studentApplicationStatusVC.tableView.reloadData()
            
            self.navigationController?.popViewController(animated: true)
            showAlertAnyWhere(message: "Application Deleted")
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
       
       if(self.company.text!.isEmpty) {
            showAlertAnyWhere(message: "Please enter company.")
           return false
       }
       
       if(self.location.text!.isEmpty) {
            showAlertAnyWhere(message: "Please enter location.")
           return false
       }
       
       if(!CommonMethods.shared.isValidEmail(testStr: pocEmail.text!)) {
            showAlertAnyWhere(message: "Please enter valid email.")
           return false
       }
       
       if(self.pocContact.text!.isEmpty) {
            showAlertAnyWhere(message: "Please enter POC contact.")
           return false
       }
       
       
       return true
   }
   
   
}
