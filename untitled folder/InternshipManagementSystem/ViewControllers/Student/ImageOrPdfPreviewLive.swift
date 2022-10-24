
import UIKit
import PDFKit
import FirebaseStorage

class ImageOrPdfPreviewLive: UICollectionViewCell {
  
   @IBOutlet weak var pdfView: UIView!
   @IBOutlet weak var container: UIView!
   static let idenifier = String(describing: ImageOrPdfPreviewLive.self)
   @IBOutlet weak var attachmentImage: UIImageView!
   @IBOutlet weak var deleteButton: UIButton!
   
   func setData(attchment:UploadFileList,frame:CGRect) {
       
     
       
       attachmentImage.isHidden = false
       self.container.isHidden = false
       self.pdfView.isHidden = true

       if  attchment.storageFileType == "pdf" {
           
//           let pdfView = PDFView()
//           pdfView.translatesAutoresizingMaskIntoConstraints = true
//           pdfView.document = pdf
//           pdfView.autoScales = true
//           pdfView.frame = frame
//           self.pdfView.isHidden = false
//           self.pdfView.addSubview(pdfView)

        }else {
            attachmentImage?.contentMode = .scaleAspectFit
            
       let url =  "gs://internshipmanagementsyst-e9f1e.appspot.com/" + attchment.backendLocation!
            
            
            let ref2 = Storage.storage().reference(forURL: url )

            
            ref2.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
                    if let err = error {
                       print(err)
                  } else {
                    if let image  = data {
                         
                       // self.attachmentImage.image = UIImage(named: "deletRound")
                        //self.attachmentImage.
                         self.attachmentImage.image = UIImage(data: image)

                         // Use Image
                    }
                 }
            }
            
//            FireStoreManager.shared.getImageFromURL(){
//
//            }
           // self.pdfView.isHidden = true
        }
       
       
   }

}


