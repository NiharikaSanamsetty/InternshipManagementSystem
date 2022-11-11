 

import UIKit

class ApplicationStatusCell: UITableViewCell {

    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var company: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var copyButton: UIButton!
    
    @IBOutlet weak var id: UILabel!
    
    @IBOutlet weak var attchmentButton: UIButton!
    
    @IBOutlet weak var facultyEmail: UILabel!
    @IBOutlet weak var facultyName: UILabel!
    
    func setData(data:StudentFormData) {
       
        self.company.text = data.company
        self.location.text = data.location
        self.date.text = data.date
        self.status.text = data.status
        self.id.text = data.id
        self.facultyName.text = data.professorName
        self.facultyEmail.text = data.professorEmail
        
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
