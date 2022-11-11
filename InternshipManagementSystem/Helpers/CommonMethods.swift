
import Foundation

class CommonMethods {

    
static let shared  = CommonMethods()
    
    
func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}
    
func isValidPhone(phone: String) -> Bool {
            let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phoneTest.evaluate(with: phone)
}
    
    
}


func showDepartmentDialog(completionHandler:@escaping (String) -> Void){
    
    
    if(FireStoreManager.shared.departments.isEmpty) {
        
        FireStoreManager.shared.getCategories { _ in
            
            var picker: TCPickerViewInput = TCPickerView()
            picker.title = "Please Select Department"
            let array = FireStoreManager.shared.departments
            
                    let values = array.map { TCPickerView.Value(title: $0) }
                    picker.values = values
                    picker.selection = .single
                    picker.completion = { (selectedIndexes) in
                        for i in selectedIndexes {
                            print(values[i].title)
                            completionHandler(values[i].title)
                        }
                    }
                    picker.closeAction = {
                        print("Handle close action here")
                    }
                    picker.show()
        }
        
    }else {
        
        var picker: TCPickerViewInput = TCPickerView()
        picker.title = "Please Select Department"
        let array = FireStoreManager.shared.departments
        
                let values = array.map { TCPickerView.Value(title: $0) }
                picker.values = values
                picker.selection = .single
                picker.completion = { (selectedIndexes) in
                    for i in selectedIndexes {
                        print(values[i].title)
                        completionHandler(values[i].title)
                    }
                }
                picker.closeAction = {
                    print("Handle close action here")
                }
                picker.show()
        
    }
   
    
}
