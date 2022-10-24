 

import UIKit


var studentApplicationStatusVC :StudentApplicationStatusVC!

class StudentApplicationStatusVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var idTv: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var querySnapshot =  [[String:String]]()

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
           
              
            let documentId = document.documentID
            let company = document.data()!["company"] as? String ?? ""
            let contact = document.data()!["contact"] as? String ?? ""
            let date = document.data()!["date"] as? String ?? ""
            let department = document.data()!["department"] as? String ?? ""
            let email = document.data()!["email"] as? String ?? ""
            let firstName = document.data()!["firstName"] as? String ?? ""
            let lastName = document.data()!["lastName"] as? String ?? ""
            let location = document.data()!["location"] as? String ?? ""
            let pocContact = document.data()!["pocContact"] as? String ?? ""
            let pocEmail = document.data()!["pocEmail"] as? String ?? ""
            let status = document.data()!["status"] as? String ?? ""
           
         
            
            let dict = ["company":company,"contact":contact, "date":date,"department":department,"email":email,"firstName":firstName,"lastName":lastName,"location":location,"pocContact":pocContact,"pocEmail":pocEmail,"status":status,"id" : documentId]
            
            self.querySnapshot.append( dict)
            
            self.tableView.reloadData()
          
        }
        
        
}
    
    
    
    @IBAction func onUpdate(_ sender: Any) {
        
        
        if(querySnapshot.count > 0 ) {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateFormViewController") as! UpdateFormViewController
            vc.querySnapshot = self.querySnapshot.first!
            self.navigationController!.pushViewController(vc, animated: true)
            
            
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
        return 150
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ApplicationStatusCell") as! ApplicationStatusCell
        let data = self.querySnapshot[indexPath.row]
       
        // un comment here
      //  cell.setData(company: data["company"]!, location: data["location"]!, date: data["date"]!, status: data["status"]!, id: data["id"]!)
        
        
        return cell
    }
    
    
}
