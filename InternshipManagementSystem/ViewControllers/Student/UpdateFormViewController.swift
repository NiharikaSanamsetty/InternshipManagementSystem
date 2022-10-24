
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
    
    
      
}
