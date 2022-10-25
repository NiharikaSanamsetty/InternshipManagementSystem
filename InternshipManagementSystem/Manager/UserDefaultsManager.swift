 
import Foundation

class UserDefaultsManager  {
    
    
    static  let shared =  UserDefaultsManager()
    
     
    func clearUserDefaults() {
        
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()

            dictionary.keys.forEach
            {
                key in defaults.removeObject(forKey: key)
            }
    }
    
   
    
    
    func isLoggedIn() -> Bool{
        
        let email = getEmail()
        
        if(email.isEmpty) {
            return false
        }else {
           return true
        }
      
    }
     
    func getEmail()-> String {
        
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        
        print(email)
       return email
    }
    
    func getFirstName()-> String {
       return UserDefaults.standard.string(forKey: "firstName") ?? ""
    }
    
    func getLastName()-> String {
       return UserDefaults.standard.string(forKey: "lastName") ?? ""
    }
    
    func getContact()-> String {
       return UserDefaults.standard.string(forKey: "contact") ?? ""
    }
    
    func getDepartment()-> String {
       return UserDefaults.standard.string(forKey: "department") ?? ""
    }
    
    func getUserType()-> String {
       return UserDefaults.standard.string(forKey: "userType") ?? ""
    }
    
    
    func saveData(firstName:String,lastName:String,email:String,contact:String,department:String,userType:String) {
        
        UserDefaults.standard.setValue(firstName, forKey: "firstName")
        UserDefaults.standard.setValue(lastName, forKey: "lastName")
        UserDefaults.standard.setValue(email, forKey: "email")
        UserDefaults.standard.setValue(contact, forKey: "contact")
        UserDefaults.standard.setValue(department, forKey: "department")
        UserDefaults.standard.setValue(userType, forKey: "userType")
    }
  
    
}
