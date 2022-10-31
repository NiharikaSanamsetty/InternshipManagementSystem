 
import UIKit
import FirebaseFirestore

class FacultyDashBoard: UIViewController , UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate{

  @IBOutlet weak var tableView: UITableView!

  @IBOutlet weak var searchTextField: UITextField!

   var tempSnapshot =  [StudentFormData]()
   var filterSnapShot =  [StudentFormData]()
   
  
    
  override func viewDidLoad() {
      super.viewDidLoad()

      self.tableView.delegate = self
      self.tableView.dataSource = self
      self.searchTextField.delegate = self

  }
   
   

  @IBAction func onSearch(_ sender: Any) {

      self.view.endEditing(true)

      if(!searchTextField.text!.isEmpty) {
          self.performSearch()
      }else {
          filterSnapShot = tempSnapshot
          self.tableView.reloadData()
      }
  }

    
    
    

  

  override func viewWillAppear(_ animated: Bool) {
      self.getApplications()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return filterSnapShot.count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 180
  }


 
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

      let id =  self.filterSnapShot[indexPath.row].id

      
      let dialog = SelectionDialog(title: "Please Select Status", closeButtonTitle: "Close")
      
      dialog.addItem(item: "Pending", icon: UIImage(named: "pending")!) {
           
          dialog.close()
          
          FireStoreManager.shared.changeStatusOfApplication(id: id, status: "Pending", completionHandler: {
              self.getApplications()
          })
      }
      
      dialog.addItem(item: "Approved", icon: UIImage(named: "approved")!) {
         
          dialog.close()
          
          FireStoreManager.shared.changeStatusOfApplication(id: id, status: "Approved", completionHandler: {
              self.getApplications()
          })
          
          
         
      }
      
      dialog.addItem(item: "Rejected", icon: UIImage(named: "rejected")!) {
          
          dialog.close()
          
          self.showInputDialog(title: "Please Add Rejection Reasons.", subtitle: "", actionTitle: "Done", cancelTitle: "Cancel", inputPlaceholder: "Please Enter Rejection Reasons.", inputKeyboardType: .default , actionHandler: { text in
               
              if (text!.isEmpty) {
                  self.showAlert(message: "Please add Rejection Reasons.")
              }else {
                  
                   FireStoreManager.shared.changeStatusOfApplication(reason: text!,id: id, status: "Rejected", completionHandler: {
                                self.getApplications()
                            })
              }
             
          })

      }
      
      dialog.show()
      

  }
  @objc func copyButtonTapped(_ sender: UIButton){


      UIPasteboard.general.string = self.filterSnapShot[sender.tag].id
      globalCopiedID = self.filterSnapShot[sender.tag].id
      let toast = Toast(text: "Id copied")
      toast.show()
  }
   

   




extension FireStoreManager {
    
    
    func getApplicationFourmsByDepartment(department:String,completionHandler:@escaping (QuerySnapshot) -> Void){
        
        
       let  query = db.collection("StudentApplicationForms").whereField("department", isEqualTo: department)
        
        query.getDocuments { (snapshot, err) in
                    
            if let _ = err {
                  return
            }else {
                
                
                if let querySnapshot = snapshot {
                    return completionHandler(querySnapshot)
                }else {
                    return
                }
               
            }
        }
          
    }
    
}


extension UIViewController {
    
    
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}
   
 
}
