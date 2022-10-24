 
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import Firebase
import FirebaseFirestoreSwift
 

class FireStoreManager {

    
    public static let shared = FireStoreManager()
    var attachmentsArray: [AttachmentArray] = []
    
   
    var db: Firestore!
    var dbRef : CollectionReference!
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        dbRef = db.collection("LoginDb")
       
    }
    
    
  
    func getImageFromURL(url:String,completionHandler:@escaping (Any) -> Void){
        
    }
    
    
    func deleteDocument(documentId:String,completionHandler:@escaping (Any) -> Void){
        
        let dbRef = db.collection("StudentApplicationForms").document(documentId)
        
        if ( !documentId.isEmpty) {
            
            dbRef.delete { error in
            
                if let error = error {
                    showAlertAnyWhere(message: "There is something Wrong")
                }else {
                    completionHandler(true)
                }
                
            }
           
          }

    }
    
    func updateData(documentId:String,data:StudentFormData) {
        
        let dbRef = db.collection("StudentApplicationForms").document(documentId)
        
        if ( !documentId.isEmpty) {
            
            try! dbRef.setData(from:data) { error in
                 
                if let _ = error {
                    showAlertAnyWhere(message: "There is something Wrong")
                }else {
                    studentApplicationStatusVC.querySnapshot.removeAll()
                    studentApplicationStatusVC.tableView.reloadData()
                    showAlertAnyWhere(message: "Application Updated")
                }
                
            }
           
          }
           
    }
        
    func signUp(firstName:String,lastName:String,email:String,contact:String,department:String,password:String,userType:String) {
        
        self.checkAlreadyExistAndSignup(firstName: firstName, lastName: lastName, email: email, contact: contact, department: department, password: password , userType:userType)
    }
    
    func login(email:String,password:String ,userType:String) {
        
        getQueryFromFirestore(field: "email", compareValue: email) { querySnapshot in
             
            print(querySnapshot.count)
            
            if(querySnapshot.count == 0) {
                showAlertAnyWhere(message: "Email id not found!!")
            }else {
                
                for document in querySnapshot.documents {
                    print("\(document.documentID)")
                    
                    
                    if let pwd = document.data()["password"] as? String{
                    
                        if(pwd == password) {
                            
                            let firstName = document.data()["firstName"] as? String ?? ""
                            let lastName = document.data()["lastName"] as? String ?? ""
                            let email = document.data()["email"] as? String ?? ""
                            let contact = document.data()["contact"] as? String ?? ""
                            let department = document.data()["department"] as? String ?? ""
                            let type = document.data()["userType"] as? String ?? ""
                            
                            
                            if(userType == type ) {
                                UserDefaultsManager.shared.saveData(firstName: firstName, lastName: lastName, email: email, contact: contact, department: department, userType: userType)
                                
                                SceneDelegate.shared?.checkLogin()
                                
                            }else {
                                showAlertAnyWhere(message: "You are not allow login for this role")
                            }
                            
                        }else {
                            showAlertAnyWhere(message: "Password doesn't match")
                        }
                            
                            
                    }else {
                        showAlertAnyWhere(message: "Something went wrong!!")
                    }
                   
                    
                }
                
                
                
            }
        }
    }
    

    
    func checkAlreadyExistAndSignup(firstName:String,lastName:String,email:String,contact:String,department:String,password:String , userType:String) {
        
        
        getQueryFromFirestore(field: "email", compareValue: email) { querySnapshot in
             
            print(querySnapshot.count)
            
            if(querySnapshot.count > 0) {
                showAlertAnyWhere(message: "This Email is Already Registerd!!")
            }else {
                
                // Signup
                
                let data = ["firstName":firstName , "lastName" : lastName , "email" : email , "contact" : contact , "department" : department , "password" : password , "userType" : userType  ]
                
                self.addDataToFireStore(data: data) { _ in
                    
                    showAlertAnyWhere(message: "Registration Success!! You can login now")
                    
                }
               
            }
        }
    }
}


extension FireStoreManager {
    
    
    
    func addDataToFireStore(data:[String:Any] ,completionHandler:@escaping (Any) -> Void){
        
        dbRef.addDocument(data: data) { err in
                   if let err = err {
                       showAlertAnyWhere(message: "Error adding document: \(err)")
                   } else {
                       completionHandler("success")
                   }
     }
        
        
    }
    
    
    func getApplicationForms(completionHandler:@escaping (QuerySnapshot) -> Void){
        
      
        db.collection("StudentApplicationForms").whereField("email", isEqualTo: UserDefaultsManager.shared.getEmail()).getDocuments { querySnapshot, err in
      
            if let _ = err {
                  return
            }else {
                
                if let querySnapshot = querySnapshot {
                    return completionHandler(querySnapshot)
                }else {
                    return
                }
               
            }
            
        }

    }
    
    
    func getApplicationFormsFromID(id:String,completionHandler:@escaping (DocumentSnapshot) -> Void){
        
        
        let dbRef = db.collection("StudentApplicationForms")
        
        let pathToQuery =  dbRef.document(id)
        
      
        pathToQuery.getDocument { snap, error in
            
            if let snap = snap {
                
                if(snap.exists) {
                    
                  print(snap)
                  return completionHandler(snap)
                    
                }else {
                    
                    print("Error NO DATA")
                    showAlertAnyWhere(message: "Application ID Not Exist!!")
                    return
                }
                
            } else if let error = error {
                print("Error: \(error)")
                return
            }
           
        }


    }
    
    func searchApplicationStatusByCompanyName(companyName:String,completionHandler:@escaping (QuerySnapshot) -> Void){
        
        let dbRef = db.collection("StudentApplicationForms")
        
        dbRef.whereField("company", isEqualTo: companyName.lowercased()).getDocuments { querySnapshot, err in
            
            if let err = err {
                
                showAlertAnyWhere(message: "Error getting documents: \(err)")
                            return
            }else {
                
                if let querySnapshot = querySnapshot {
                    return completionHandler(querySnapshot)
                }else {
                    showAlertAnyWhere(message: "Something went wrong!!")
                }
               
            }
        }
        
       
    }
    
    func getQueryFromFirestore(field:String,compareValue:String,completionHandler:@escaping (QuerySnapshot) -> Void){
        
        dbRef.whereField(field, isEqualTo: compareValue).getDocuments { querySnapshot, err in
            
            if let err = err {
                
                showAlertAnyWhere(message: "Error getting documents: \(err)")
                            return
            }else {
                
                if let querySnapshot = querySnapshot {
                    return completionHandler(querySnapshot)
                }else {
                    showAlertAnyWhere(message: "Something went wrong!!")
                }
               
            }
        }
        
    }
    
}


extension FireStoreManager  {
    
 
    
    func submitStudentApplication(studentFormData: StudentFormData, attchmentDocs: [AttachmentArray] , completion: @escaping (Bool)->()) {
        
       
     
            let dbRef = db.collection("StudentApplicationForms").document()
            typealias FileCompletionBlock = () -> Void
            let documentID = dbRef.documentID
            var newStudentFormData = studentFormData
            newStudentFormData.id = documentID
       
    
            
        
              self.uploadFiles(classroomId: UserDefaultsManager.shared.getEmail(), attachments: attchmentDocs) { success in
                
                  
                  completion(true)
                  
                  do {
                     try dbRef.setData(from: newStudentFormData) { error in
                                      completion(true)
                                  }
                    } catch let error {
                                  print("Error writing Study Material Topic to Firestore: \(error)")
                        completion(false )
                }

                  
                  
                  
               
                
            }
         
        
        
    }
    
    
    func uploadFiles(classroomId:String,attachments: [AttachmentArray] , completion: @escaping (Bool)->()) {
        
        FirFile.shared.startUploading(classroomId: classroomId, attachments: attachments) {
             
            print("All Upload Success")
            completion(true)
        }
        
    }
   
    
}






class FirFile: NSObject {

    
    typealias FileCompletionBlock = () -> Void
    var block: FileCompletionBlock?
    var attachments =  [AttachmentArray]()
    var classRoomId = ""
    
    static let shared: FirFile = FirFile()
   
    /// Path
    var storageRef = Storage.storage().reference()

    /// Current uploading task
    var currentUploadTask: StorageUploadTask?

    func upload(type:String,data: Data,
                withName fileName: String,
                block: @escaping (_ error: Error?) -> Void) {

        // Create a reference to the file you want to upload
        
        var fileRef = storageRef.child("")
        
        if(type == "pdf") {
             fileRef = storageRef.child("Documents").child(UserDefaultsManager.shared.getEmail()).child("docs").child("pdf").child(fileName)
             
        }else {
            fileRef = storageRef.child("Documents").child(UserDefaultsManager.shared.getEmail()).child("docs").child("images").child(fileName)
        }
       

        /// Start uploading
        upload(data: data, withName: fileName, atPath: fileRef) { (error) in
            block(error)
        }
    }

    func upload(data: Data,
                withName fileName: String,
                atPath path:StorageReference,
                block: @escaping (_ error: Error?) -> Void) {

        // Upload the file to the path
        self.currentUploadTask = path.putData(data, metadata: nil) { (metaData, error) in
            
            block(error)
        }
    }

    func cancel() {
        self.currentUploadTask?.cancel()
    }
    
    
    
  
    func startUploading(classroomId:String,attachments:[AttachmentArray] , completion: @escaping FileCompletionBlock) {

        self.classRoomId = classroomId
        self.attachments = attachments
         if attachments.count == 0 {
            completion()
            return;
         }

         block = completion
         uploadImageOrPdf(forIndex: 0)
    }

    func uploadImageOrPdf(forIndex index:Int) {

         if index < attachments.count {
              /// Perform uploading
              
               let attachment =  attachments[index]
               var data = Data()
               var type = ""
               let fileName =  attachment.uploadFile.name ?? "NA"
             
             
             if let pdf = attachment.pdf {
                 data = pdf.dataRepresentation()!
                 type = "pdf"
             } else if let image = attachment.image {
                 if let imageData = image.jpegData(compressionQuality: 0.3) {
                     data =  imageData
                 }else {
                     data = image.jpegData(compressionQuality: 1)!
                 }
                 type = "image"
             }
             
             FirFile.shared.upload(type: type, data: data, withName: fileName, block: { (error) in
                  /// After successfully uploading call this method again by increment the **index = index + 1**
                  
                  if let error = error {
                      print(error)
                  }else {
                      self.uploadImageOrPdf(forIndex: index + 1)
                  }
                
               })
            return;
          }

          if block != nil {
             block!()
          }
    }
    
    
    
    
}
