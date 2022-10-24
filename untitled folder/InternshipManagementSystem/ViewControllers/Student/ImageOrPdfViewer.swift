import PDFKit

import UIKit

class ImageOrPdfViewer: UIViewController {

   
   @IBOutlet weak var mainContainer: UIView!
   
   @IBOutlet weak var pdfView: UIView!
   @IBOutlet weak var attachmentImage: UIImageView!
   var attchment : AttachmentArray!
   
 
   override func viewDidAppear(_ animated: Bool) {
       
       self.mainContainer.layer.cornerRadius = 10
       self.setData()
   }

   func setData() {
       
      
       
       if let pdf = attchment.pdf {
           let pdfView = PDFView()
           pdfView.translatesAutoresizingMaskIntoConstraints = true
           pdfView.document = pdf
           pdfView.frame = attachmentImage.frame
           pdfView.clipsToBounds = true
           self.pdfView.isHidden = false
           self.pdfView.addSubview(pdfView)
           pdfView.autoScales = true
           self.mainContainer.clipsToBounds  = true
           
           

       }else {
           attachmentImage?.contentMode = .scaleAspectFill
           attachmentImage.image = attchment.image!
           self.pdfView.isHidden = true
       }
       
       
   }

   
   
   @IBAction func onClose(_ sender: Any) {
       self.dismiss(animated: true)
   }
   

}
