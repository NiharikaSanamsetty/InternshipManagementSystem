 
 
import UIKit

class StudentDashBoard: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        FireStoreManager.shared.getCategories() { _ in
             
        }
    }
    

    @IBAction func onLogOut(_ sender: Any) {
        
        UserDefaultsManager.shared.clearUserDefaults()
        
        SceneDelegate.shared?.checkLogin()
        
    }
     
    
    @IBAction func onSendDetails(_ sender: Any) {
        
        if let url = URL(string: "https://ssbprod.nwmissouri.edu/PROD/twbkwbis.P_GenMenu?name=homepage") {
            UIApplication.shared.open(url)
        }
        
    }
    

}
