
import UIKit
import PDFKit

class ImagePdfCell: UICollectionViewCell {
  
   @IBOutlet weak var pdfView: UIView!
   @IBOutlet weak var container: UIView!
   static let idenifier = String(describing: ImagePdfCell.self)
   @IBOutlet weak var attachmentImage: UIImageView!
   @IBOutlet weak var deleteButton: UIButton!
   
   func setData(attchment:AttachmentArray,frame:CGRect) {
       
     /* guard let path = Bundle.main.url(forResource: "test", withExtension: "pdf") else { return }
       
       if let document = PDFDocument(url: path) {
           let pdfView = PDFView()
           pdfView.translatesAutoresizingMaskIntoConstraints = true
           pdfView.document = document
           pdfView.autoScales = true
           pdfView.frame = frame
           self.pdfView.isHidden = false
           self.pdfView.addSubview(pdfView)
       } */

       
       

        if let pdf = attchment.pdf {
           let pdfView = PDFView()
           pdfView.translatesAutoresizingMaskIntoConstraints = true
           pdfView.document = pdf
           pdfView.autoScales = true
           pdfView.frame = frame
           self.pdfView.isHidden = false
           self.pdfView.addSubview(pdfView)

        }else {
            attachmentImage?.contentMode = .scaleAspectFit
            attachmentImage.image = attchment.image!
            self.pdfView.isHidden = true
        }
       
       
   }

}


