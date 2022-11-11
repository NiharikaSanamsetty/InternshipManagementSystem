 
 
import UIKit


var globalCopiedID = ""

class AddDropViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate{

   @IBOutlet weak var tableView: UITableView!

   @IBOutlet weak var searchTextField: UITextField!

//   var tempSnapshot =  [[String:String]]()
//   var filterSnapShot =  [[String:String]]()

    var tempSnapshot =  [StudentFormData]()
    var filterSnapShot =  [StudentFormData]()
    

   override func viewDidLoad() {
       super.viewDidLoad()

       self.tableView.delegate = self
       self.tableView.dataSource = self
       self.searchTextField.delegate = self

   }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        if let text = textField.text,
                  let textRange = Range(range, in: text) {
                  let updatedText = text.replacingCharacters(in: textRange,
                                                              with: string)
            
            if(updatedText.isEmpty) {
                self.searchTextField.text = ""
                self.onSearch(UIButton())
            }else  {
               // self.onSearch(UIButton())
                
            }
            
        }
        
        return true
    
    }

   @IBAction func onSearch(_ sender: Any) {

       self.view.endEditing(true)

       if(!searchTextField.text!.isEmpty) {
           self.performSearch()
       }else {
           filterSnapShot = tempSnapshot
           self.tableView.reloadData()
       }
   }


   func performSearch() {

       var temp =  [StudentFormData]()
       
       for snap in tempSnapshot {
           
           let company = snap.company!.lowercased()
           
           if(company.contains(self.searchTextField.text!.lowercased())) {
               temp.append(snap)
           }
       }
       self.filterSnapShot.removeAll()
       self.filterSnapShot = temp
       self.tableView.reloadData()
   }

   override func viewWillAppear(_ animated: Bool) {
       self.getApplications()
   }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return filterSnapShot.count
   }

   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 240
   }


   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       let cell = self.tableView.dequeueReusableCell(withIdentifier: "ApplicationStatusCell") as! ApplicationStatusCell
       let data = self.filterSnapShot[indexPath.row]
       cell.copyButton.tag = indexPath.row
       cell.attchmentButton.tag = indexPath.row
       cell.copyButton.addTarget(self, action: #selector(copyButtonTapped(_:)), for: .touchUpInside)
       cell.attchmentButton.addTarget(self, action: #selector(showAttchment(_:)), for: .touchUpInside)
       cell.setData(data: data)


       return cell
   }

   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       let id =  self.filterSnapShot[indexPath.row].id

      print(id)

   }
   @objc func copyButtonTapped(_ sender: UIButton){


       UIPasteboard.general.string = self.filterSnapShot[sender.tag].id
       globalCopiedID = self.filterSnapShot[sender.tag].id
       let toast = Toast(text: "Id copied")
       toast.show()
   }
    
    @objc func showAttchment(_ sender: UIButton){

        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PreViewVC") as! PreViewVC
        vc.attachments = self.filterSnapShot[sender.tag].uploadFileList!
        self.navigationController?.pushViewController(vc, animated: true)
        
    
    }


    
    
   func getApplications() {

       self.tempSnapshot.removeAll()

       FireStoreManager.shared.getApplicationForms { [self]  querySnapshot in

           
           var itemsArray = [StudentFormData]()
           
           for (_,document) in querySnapshot.documents.enumerated() {
               do {
                   let item = try document.data(as: StudentFormData.self)
                   itemsArray.append(item)
                   
                   print(itemsArray.count)
                
               }catch let error {
                   print(error)
               }
           }
           
          
           self.filterSnapShot =  itemsArray
           self.tableView.reloadData()
       
        
 
       }
}


}
