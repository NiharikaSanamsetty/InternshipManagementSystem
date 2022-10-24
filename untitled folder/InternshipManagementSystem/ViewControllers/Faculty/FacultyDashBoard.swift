 
import UIKit

class FacultyDashBoard: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func onLogOut(_ sender: Any) {
        
        UserDefaultsManager.shared.clearUserDefaults()
        
        SceneDelegate.shared?.checkLogin()
        
    }
    

}
