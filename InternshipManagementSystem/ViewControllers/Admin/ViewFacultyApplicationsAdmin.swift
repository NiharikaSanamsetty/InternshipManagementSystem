
import UIKit
import FirebaseFirestore

class ViewFacultyApplicationsAdmin: UIViewController , UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate{

 @IBOutlet weak var tableView: UITableView!

 @IBOutlet weak var searchTextField: UITextField!

  var filterSnapShot =  [StudentFormData]()
  
  var searchedEmail = ""
   
 override func viewDidLoad() {
     super.viewDidLoad()

     self.tableView.delegate = self
     self.tableView.dataSource = self
     self.searchTextField.delegate = self

 }
  
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     
//      if let text = textField.text,
//                let textRange = Range(range, in: text) {
//                let updatedText = text.replacingCharacters(in: textRange,
//                                                            with: string)
//
//          if(updatedText.isEmpty) {
//              self.searchTextField.text = ""
//              self.onSearch(UIButton())
//          }else  {
//             // self.onSearch(UIButton())
//
//          }
//
//      }
      
      return true
  
  }

 @IBAction func onSearch(_ sender: Any) {

     self.view.endEditing(true)

     if(!searchTextField.text!.isEmpty) {
         self.performSearch()
     }
 }

   
   
   @IBAction func onLogOut(_ sender: Any) {
       
       UserDefaultsManager.shared.clearUserDefaults()
       
       SceneDelegate.shared?.checkLogin()
       
   }

 func performSearch() {
     
     if(CommonMethods.shared.isValidEmail(testStr: self.searchTextField.text!)) {
         
         self.searchedEmail = self.searchTextField.text!
         
         self.getApplications(email: self.searchTextField.text!)
         
         
     }

    
 }

 override func viewWillAppear(_ animated: Bool) {
    // self.getApplications()
 }

 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return filterSnapShot.count
 }

 func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 180
 }


 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

     let cell = self.tableView.dequeueReusableCell(withIdentifier: "ApplicationStatusCellFaculty") as! ApplicationStatusCellFaculty
     let data = self.filterSnapShot[indexPath.row]
     cell.copyButton.tag = indexPath.row
     cell.attchmentButton.tag = indexPath.row
     cell.copyButton.addTarget(self, action: #selector(copyButtonTapped(_:)), for: .touchUpInside)
     cell.attchmentButton.addTarget(self, action: #selector(showAttchment(_:)), for: .touchUpInside)
     cell.setData(data: data)


     return cell
 }

 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

     let id =  self.filterSnapShot[indexPath.row].id
     let name =  self.filterSnapShot[indexPath.row].firstName ?? ""
     let email =  self.filterSnapShot[indexPath.row].email!

     
     let dialog = SelectionDialog(title: "Please Select Status", closeButtonTitle: "Close")
     
     dialog.addItem(item: "Pending", icon: UIImage(named: "pending")!) {
          
         dialog.close()
         
         FireStoreManager.shared.changeStatusOfApplication(id: id, status: "Pending", completionHandler: {
             self.getApplications(email: self.searchedEmail)
         })
     }
     
     dialog.addItem(item: "Approved", icon: UIImage(named: "approved")!) {
        
         dialog.close()
         
         FireStoreManager.shared.changeStatusOfApplication(id: id, status: "Approved", completionHandler: {
             self.getApplications(email: self.searchedEmail)
         })
         
         self.sendApporvedEmail(toEmail: email, toName: name)
         
        
     }
     
     dialog.addItem(item: "Rejected", icon: UIImage(named: "rejected")!) {
         
         dialog.close()
         
         self.showInputDialog(title: "Please Add Rejection Reasons.", subtitle: "", actionTitle: "Done", cancelTitle: "Cancel", inputPlaceholder: "Please Enter Rejection Reasons.", inputKeyboardType: .default , actionHandler: { text in
              
             if (text!.isEmpty) {
                 self.showAlert(message: "Please add Rejection Reasons.")
             }else {
                 
                  FireStoreManager.shared.changeStatusOfApplication(reason: text!,id: id, status: "Rejected", completionHandler: {
                      self.getApplications(email: self.searchedEmail)
                           })
                 self.sendRejectedEmail(toEmail: email, toName: name)
             }
            
         })

     }
     
     dialog.show()
     

 }


func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

     let cell = self.tableView.dequeueReusableCell(withIdentifier: "ApplicationStatusCellFaculty") as! ApplicationStatusCellFaculty
     let data = self.filterSnapShot[indexPath.row]
     cell.attchmentButton.tag = indexPath.row
     cell.attchmentButton.addTarget(self, action: #selector(showAttchment(_:)), for: .touchUpInside)
     cell.setData(data: data)

     return cell
 }


 @objc func copyButtonTapped(_ sender: UIButton){


     UIPasteboard.general.string = self.filterSnapShot[sender.tag].id
     globalCopiedID = self.filterSnapShot[sender.tag].id
     let toast = Toast(text: "Id copied")
     toast.show()
 }
  


  
  
    func getApplications(email:String) {

     self.filterSnapShot.removeAll()

     
        
        FireStoreManager.shared.getApplicationFourmsByQuery(field: "professorEmail", compareValue: email) { querySnapshot in
       
         
         var itemsArray = [StudentFormData]()
         
         for (_,document) in querySnapshot.documents.enumerated() {
             do {
                 let item = try document.data(as: StudentFormData.self)
                 itemsArray.append(item)
                 
                 print(itemsArray.count)
              
             }catch let error {
                 print(error)
             }
         }
         
         
         
         self.filterSnapShot = itemsArray
         self.tableView.reloadData()
     
      

     }
}


}



 
 

extension ViewFacultyApplicationsAdmin {
   
   func searchByStatus(status:String) {
       
      
       
   }
   
   
   @IBAction func onFilter(_ sender: Any) {
       
   }
}



extension ViewFacultyApplicationsAdmin {
   
   
   func sendApporvedEmail(toEmail:String,toName:String) {
       let subject = "Application Approved"
       let emailBody = "<h1>Congratulations  \(toName) your Application got Approved.</h1>"
       sendEmail(to: toEmail, subject: subject, emailBody: emailBody)
       
   }
   
   
   func sendRejectedEmail(toEmail:String,toName:String) {
       
       let subject = "Application Approved"
       let emailBody = "<h1>Sorry \(toName) your Application got Rejected.</h1>"
       sendEmail(to: toEmail, subject: subject, emailBody: emailBody)
   }
}
