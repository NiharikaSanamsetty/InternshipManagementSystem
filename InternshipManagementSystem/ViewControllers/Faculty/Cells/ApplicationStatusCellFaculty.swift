

import UIKit

class ApplicationStatusCellFaculty: UITableViewCell {

    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var status: UILabel!
   
   @IBOutlet weak var company: UILabel!
   
   @IBOutlet weak var location: UILabel!
   
   @IBOutlet weak var date: UILabel!
   
   @IBOutlet weak var copyButton: UIButton!
   
   @IBOutlet weak var id: UILabel!
   
   @IBOutlet weak var attchmentButton: UIButton!
   
   
   func setData(data:StudentFormData) {
       self.studentName.text = data.firstName! +  " " +  (data.lastName ?? "")
       self.company.text = data.company
       self.location.text = data.location
       self.date.text = data.date
       self.status.text = data.status
       self.id.text = data.id
       
       if(data.status == "Pending") {
           self.status.textColor = .orange
       }
       
       if(data.status == "Approved") {
           self.status.textColor = .green
       }
       
       if(data.status == "Rejected") {
           self.status.textColor = .red
       }
       
       
       if  attchmentButton != nil {
           
           if(data.uploadFileList!.count  == 0) {
               self.attchmentButton!.isHidden = true
           }else {
               self.attchmentButton!.isHidden = false
           }
           
       }
      
       
   }
}
