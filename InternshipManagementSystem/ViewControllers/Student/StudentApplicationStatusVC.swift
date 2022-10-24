 

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
         
        cell.setData(data:querySnapshot[indexPath.row] )
        
       
        return cell
    }
    
    
}
