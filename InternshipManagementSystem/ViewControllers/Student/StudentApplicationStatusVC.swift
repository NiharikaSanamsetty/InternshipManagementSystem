 

import UIKit


var studentApplicationStatusVC :StudentApplicationStatusVC!

class StudentApplicationStatusVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var idTv: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var querySnapshot =  [StudentFormData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.idTv.text = globalCopiedID
        studentApplicationStatusVC = self
    }
    
    
    @IBAction func onGetStatus(_ sender: Any) {
        
        if(idTv.text!.isEmpty) {
            return
        }else {
            self.fetchApplication()
        }
        
    }
   
    func fetchApplication() {
        
        self.querySnapshot.removeAll()
        
        FireStoreManager.shared.getApplicationFormsFromID(id: self.idTv.text!) { document in
           
            do {
                
            let item = try document.data(as: StudentFormData.self)
            self.querySnapshot.append( item)
            self.tableView.reloadData()
          
            }
               catch let error {
                print(error)
            }
        }
        
        
}
    
    
    
    @IBAction func onUpdate(_ sender: Any) {
        
        
        if(querySnapshot.count > 0 ) {
            
            if(querySnapshot.first!.status == "Approved") {
                
                showOkAlertWithCallBack(message: "Application Already Approved, You Can't Update Now, but you can delete it") {
                     
                    self.showDeleteDialog()
                    
                }
                
            }else {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateFormViewController") as! UpdateFormViewController
                vc.querySnapshot = self.querySnapshot.first!
                self.navigationController!.pushViewController(vc, animated: true)
                
            }
            
          
            
        }
        
       
         
        
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        
        UserDefaultsManager.shared.clearUserDefaults()
        
        SceneDelegate.shared?.checkLogin()
        
    }
    
}


extension StudentApplicationStatusVC {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return querySnapshot.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ApplicationStatusCell") as! ApplicationStatusCell
         
        cell.setData(data:querySnapshot[indexPath.row] )
        
       
        return cell
    }
    
    
}


extension StudentApplicationStatusVC {
    
    
    func showDeleteDialog() {
        
        let refreshAlert = UIAlertController(title: "Alert", message: "Do You want to delete the application?", preferredStyle: UIAlertController.Style.alert)

            
            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                 
                
            }))
        
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
               
                FireStoreManager.shared.deleteDocument(documentId:self.querySnapshot.first!.id) { _ in
                     
                    self.querySnapshot.removeAll()
                    self.tableView.reloadData()
                    
                    showAlertAnyWhere(message: "Application Deleted")
                }
                
            }))
        

            self.present(refreshAlert, animated: true, completion: nil)
    }
}
