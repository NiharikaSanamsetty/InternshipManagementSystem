

import UIKit

extension UIViewController {

   
   func showAlert(message:String,completion: ((_ success:Bool)->Void)?){
       let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
       let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
           completion?(true)
       }
       alert.addAction(action)
       present(alert, animated: true, completion: nil)
   }
   
   func showAlert(message:String){
       let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
       let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
           
          // completion?(true)
       }
       alert.addAction(action)
       present(alert, animated: true, completion: nil)
   }
    
    func showOkAlertWithCallBack(message:String,completion:@escaping () -> Void){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
            completion()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
   
   
   func restartApp() {
       print("f")
       // get a reference to the app delegate
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
       
       // call didFinishLaunchWithOptions ... why?
       appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
   }
   
   
   func  closeAllAndMoveHome() { // main
       self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
       
   }

   

       func pushVC(viewConterlerId : String)     {
           
           let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewConterlerId)
           vc.modalPresentationStyle = .fullScreen
          // vc.navigationController?.isNavigationBarHidden = true
           self.navigationController?.pushViewController(vc, animated: true)
           
           
       }
   
  
}



func showAlertAnyWhere(message:String){
   DispatchQueue.main.async {
   let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
   let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
      // completion?(true)
   }
   alert.addAction(action)
   UIApplication.topViewController()!.present(alert, animated: true, completion: nil)
   }
}

func showOkAlertAnyWhereWithCallBack(message:String,completion:@escaping () -> Void){
   DispatchQueue.main.async {
   let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
   let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
       completion()
   }
   alert.addAction(action)
   UIApplication.topViewController()!.present(alert, animated: true, completion: nil)
   }
}


extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}




func getTodayDate()->String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM dd YYYY"
    return dateFormatter.string(from: Date())
}



 
extension UITableView {
    
    func registerCells(_ cells : [UITableViewCell.Type]) {
        for cell in cells {
            self.register(UINib(nibName: String(describing: cell), bundle: Bundle.main), forCellReuseIdentifier: String(describing: cell))
        }
    }
}
extension UICollectionView {
    
    func registerCells(_ cells : [UICollectionViewCell.Type]) {
        for cell in cells {
            self.register(UINib(nibName: String(describing: cell), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: cell))
        }
    }
}
