 
import UIKit
import MBProgressHUD
import PDFKit
import FirebaseFirestore

class StudentFourmFinal: UIViewController {

    @IBOutlet weak var tcImage: UIImageView!
    
    var tcAccept = false
    var secondPageData = [String:String]()
    var imagePicker: ImagePicker!
    var attchmentDocs: [AttachmentArray] = []
    var attachmentsArray: [UploadFileList] = []
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionContainer: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        imagePicker.pickerController.allowsEditing = false
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.registerCells([ImagePdfCell.self])
        self.collectionView?.delegate?.scrollViewDidEndScrollingAnimation?(collectionView)
           let flowLayout = UICollectionViewFlowLayout()
           flowLayout.minimumLineSpacing = 7
           flowLayout.minimumInteritemSpacing = 7
           flowLayout.scrollDirection = .horizontal
           collectionView.collectionViewLayout = flowLayout
           collectionView.clipsToBounds  = true
          self.collectionContainer.isHidden = true
        

    }
    
    @IBAction func onTC(_ sender: Any) {
        tcImage.clipsToBounds = true
        tcImage.layer.cornerRadius = 9
        tcAccept = !tcAccept
        
        if tcAccept {
            self.tcImage.backgroundColor = UIColor.black
        } else {
            self.tcImage.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func onUpload(_ sender: UIButton) {
        self.view.endEditing(true)
        self.imagePicker.present(from: sender)
    }
    
   
    @IBAction func onSubmit(_ sender: Any) {
        
        
        if(!tcAccept){
            
                   showAlert(message: "Please Accept t&c")
                    return
        
        }else {
            
            var studentFormData = StudentFormData(professorName:secondPageData["professorName"],professorEmail:secondPageData["professorEmail"],company: secondPageData["company"], contact: secondPageData["contact"], date: getTodayDate(), department: secondPageData["department"], email: secondPageData["email"], firstName: secondPageData["firstName"], lastName: secondPageData["lastName"], location: secondPageData["location"], pocContact: secondPageData["pocContact"], pocEmail: secondPageData["pocEmail"], status: "Pending", uploadFileList: [] ,id:"")
            
            if(!attchmentDocs.isEmpty){
                studentFormData.uploadFileList = self.attachmentsArray
            }
           
            
            
            MBProgressHUD().show(animated: true)
            
            FireStoreManager.shared.submitStudentApplication(studentFormData: studentFormData , attchmentDocs : attchmentDocs) { _ in
                MBProgressHUD().hide(animated: true)
                
                self.showOkAlertWithCallBack(message: "Application Form Submitted!!") {
                    SceneDelegate.shared?.checkLogin()
                }
                
               
            }
            
        }
        
        
       
        
        
    }
    
    
    
}


extension StudentFourmFinal: ImagePickerDelegate {
    
    func didSelect(pdf: PDFDocument?, path: URL) {
//
            let name = path.lastPathComponent
            
          let attachment = UploadFileList(backendLocation: "Documents/\( UserDefaultsManager.shared.getEmail())/docs/pdf/\(name )", id: name, name: name , storageFileType: StudyMaterialType.PDF.rawValue, uploadStatus: false)
    
            self.attachmentsArray.append(attachment)
            let asAttach = AttachmentArray(uploadFile: attachment, image: nil, pdf: pdf)
            self.attchmentDocs.append(asAttach)
        self.reloadAttachments()
    }
    
    func didSelect(image: UIImage?, name: String?) {
        if image == nil {return}
    
            let attachment = UploadFileList(backendLocation: "Documents/\( UserDefaultsManager.shared.getEmail())/docs/images/\(name ?? "")", id: name, name: name ?? "", storageFileType: "IMAGE", uploadStatus: false)
        
            self.attachmentsArray.append(attachment)
            let asAttach = AttachmentArray(uploadFile: attachment, image: image, pdf: nil)
            self.attchmentDocs.append(asAttach)
        self.reloadAttachments()
    }
    
    private func reloadAttachments() {
        
       
        self.collectionView.reloadData()
        
        if(self.attchmentDocs.count > 2) {
            self.collectionView.scrollToItem(at:IndexPath(item: self.attchmentDocs.count  - 1 , section: 0), at: .right, animated: true)
        }
        
        
        if(attchmentDocs.count > 0){
            self.collectionContainer.isHidden = false
        }else {
            self.collectionContainer.isHidden = true
            
        }
        }
    }
    
  

 

struct UploadFileList: Codable {
    let backendLocation, id, name, storageFileType: String?
    let uploadStatus: Bool?
}


struct StudentFormData: Codable {
    
    let professorName, professorEmail , company, contact, date, department , email, firstName, lastName, location , pocContact ,pocEmail ,status : String?
    var uploadFileList: [UploadFileList]?
    var id = ""
}

 
 


struct AttachmentArray {
    let uploadFile: UploadFileList
    let image: UIImage?
    let pdf: PDFDocument?
}


enum StudyMaterialType :String, Codable{

   case PDF,
    VIDEO,
    IMAGE,
    TEST,
    AUDIO,
    ALL_TYPE
}


 
   
  
 
 
  

extension StudentFourmFinal : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout , UIScrollViewDelegate , UIScrollViewAccessibilityDelegate {
    
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let itemWidth = 80
          let itemHeight = 80
          return CGSize(width: itemWidth, height: itemHeight)
  }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return attchmentDocs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "ImageOrPdfViewer") as! ImageOrPdfViewer
        
        vc.attchment = self.attchmentDocs[indexPath.row]
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
        let attachment = self.attchmentDocs[indexPath.row]
        
        var cell = UICollectionViewCell()
        
        cell.clipsToBounds = true
    
        
        if let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePdfCell.idenifier, for: indexPath) as? ImagePdfCell {
            customCell.setData(attchment: attachment,frame:self.collectionView.frame)
            customCell.pdfView.clipsToBounds = true
            customCell.container.clipsToBounds = true
            customCell.attachmentImage.clipsToBounds = true
            customCell.attachmentImage.contentMode = .scaleAspectFill
            customCell.deleteButton.tag = indexPath.row
            customCell.container.backgroundColor = .white
            customCell.deleteButton.isHidden = false
            customCell.pdfView.isUserInteractionEnabled = false
            customCell.deleteButton.addTarget(self, action: #selector(deleteAttachment(_:)), for: .touchUpInside)
            customCell.clipsToBounds = true
    
            cell = customCell
        }
        
      
    
         return cell
    }
    
    
    @objc func deleteAttachment(_ sender: UIButton) {
        self.attachmentsArray.remove(at: sender.tag)
        self.attchmentDocs.remove(at: sender.tag)
        self.reloadAttachments()
    }
  
    
  
    
}
