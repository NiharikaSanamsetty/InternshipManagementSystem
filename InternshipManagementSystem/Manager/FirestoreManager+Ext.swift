

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import Firebase
import FirebaseFirestoreSwift


extension FireStoreManager {
    
    func sendPassword(email:String) {
        
        getQueryFromFirestore(field: "email", compareValue: email) { querySnapshot in
             
            print(querySnapshot.count)
            
            if(querySnapshot.count == 0) {
                showAlertAnyWhere(message: "Email id not found!!")
            }else {
                
                for document in querySnapshot.documents {
                    print("\(document.documentID)")
                    
                    
                    if let pwd = document.data()["password"] as? String{
                    
                            let subject = "Reset Password"
                            let emailBody = "<h1>Your Password For Login is '" + pwd + "'.</h1>"
                            sendEmail(to: email, subject: subject, emailBody: emailBody)
                            
                            showAlertAnyWhere(message: "Password has been sent to your email")
                            
                         
                            
                    }else {
                        showAlertAnyWhere(message: "Something went wrong!!")
                    }
                   
                    
                }
            
            }
        }
    }
}
